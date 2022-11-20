//
//  UnlockManager.swift
//  Wordout
//
//  Created by Alasdair Casperd on 17/11/2022.
//

import Combine
import StoreKit

class UnlockManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
        
    private let request: SKProductsRequest
    private var loadedProducts = [SKProduct]()
    
    enum RequestState {
        case loading
        case loaded(SKProduct)
        case failed(Error?)
        case purchased
        case deferred
    }

    // Loads and saves whether the unlock has been purchased.
    var fullVersionUnlocked: Bool {
        get {
            let value = UserDefaults.standard.bool(forKey: "FULLVERSIONUNLOCKED")
            return value
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
        // Prepare to look for the product
        let productIDs = Set(["fullappunlock"])
        request = SKProductsRequest(productIdentifiers: productIDs)
        
        // This is required because we inherit from NSObject.
        super.init()

        // Start watching the payment queue.
        SKPaymentQueue.default().add(self)

        // Set ourselves up to be notified when the product request completes.
        request.delegate = self

        // Start the request
        request.start()
        
        print("Request started.")
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
}
