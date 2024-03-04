
import Foundation
import MessageUI

// A mananger used to open email sheets, adapted from 
// Code adapted from 'Hacking With Swift'

class EmailManager: NSObject, MFMailComposeViewControllerDelegate {
    
    public static let shared = EmailManager()
    
    private override init() {
        //
    }
    
    func sendEmail(subject:String, body:String, to:String){
        if !MFMailComposeViewController.canSendMail() {
            return
        }
        
        let picker = MFMailComposeViewController()
        
        picker.setSubject(subject)
        picker.setMessageBody(body, isHTML: true)
        picker.setToRecipients([to])
        picker.mailComposeDelegate = self
        
        EmailManager.getRootViewController()?.present(picker, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        EmailManager.getRootViewController()?.dismiss(animated: true, completion: nil)
    }
    
    static func getRootViewController() -> UIViewController? {
        UIApplication.shared.windows.first?.rootViewController
    }
}
