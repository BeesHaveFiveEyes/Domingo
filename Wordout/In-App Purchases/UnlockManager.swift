
import Combine
import StoreKit

// A manager to handle in-app purchases within the app
// Code adapted from 'Hacking With Swift'

class UnlockManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
        
    // An override for fullVersionUnlocked for use in previews
    private var previewValue: Bool? = nil

    private let request: SKProductsRequest
    private var loadedProducts = [SKProduct]()
    
    enum RequestState {
        case loading
        case loaded(SKProduct)
        case failed(Error?)
        case purchased
        case deferred
    }

    // Loads and saves whether the unlock has been purchased
    var fullVersionUnlocked: Bool {
        get {
            if let previewValue = previewValue {
                return previewValue
            }
            else {
                let value = UserDefaults.standard.bool(forKey: "FULLVERSIONUNLOCKED")
                return value
            }
        }

        set {
            UserDefaults.standard.set(newValue, forKey: "FULLVERSIONUNLOCKED")
        }
    }
    
    private enum StoreError: Error {
        case invalidIdentifiers, missingProduct
    }

    @Published var requestState = RequestState.loading
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        DispatchQueue.main.async { [self] in
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchased, .restored:
                    self.fullVersionUnlocked = true
                    self.requestState = .purchased
                    queue.finishTransaction(transaction)

                case .failed:
                    if let product = loadedProducts.first {
                        self.requestState = .loaded(product)
                    } else {
                        self.requestState = .failed(transaction.error)
                    }

                    queue.finishTransaction(transaction)

                case .deferred:
                    self.requestState = .deferred

                default:
                    break
                }
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            // Store the returned products for later in case needed
            self.loadedProducts = response.products

            guard let unlock = self.loadedProducts.first else {
                self.requestState = .failed(StoreError.missingProduct)
                return
            }

            if response.invalidProductIdentifiers.isEmpty == false {
                print("WARNING: Received invalid product identifiers: \(response.invalidProductIdentifiers)")
                self.requestState = .failed(StoreError.invalidIdentifiers)
                return
            }

            self.requestState = .loaded(unlock)
        }
    }
    
    func buy(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    var canMakePayments: Bool {
        SKPaymentQueue.canMakePayments()
    }
    
    override init() {
        let productIDs = Set(["fullappunlock"])
        request = SKProductsRequest(productIdentifiers: productIDs)
        super.init()
        SKPaymentQueue.default().add(self)
        request.delegate = self
        request.start()
    }
    
    init(previewValue: Bool?) {
        
        // Set value to show in previews
        self.previewValue = previewValue
                
        let productIDs = Set(["fullappunlock"])
        request = SKProductsRequest(productIdentifiers: productIDs)
        super.init()
        SKPaymentQueue.default().add(self)
        request.delegate = self
        request.start()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
}
