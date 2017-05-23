import Foundation
import UIKit

class Helper: NSObject {

    //MARK: Return nil if object is NSNull
    static func nullToNil(_ value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
}
    
    // check for iPad
    static func isDeviceIsPad()->Bool {
        var isPad = false
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad )
        {
            isPad = true /* Device is iPad */
        }
        
        return isPad
    }
    
    //MARK: Show Alert with Title
    static func showAlertWithTitle(_ conroller: UIViewController, title: String, message: String = "" ,dismissButtonTitle: String, dismissAction:@escaping ()->Void) {
        
        let validationLinkAlert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: dismissButtonTitle, style: .default) { (action) -> Void in
            dismissAction()
        }
        
        validationLinkAlert.addAction(dismissAction)
        conroller.present(validationLinkAlert, animated: true, completion: nil)
    }
    
    static func showALertWithTitleAndMessage(_ controller: UIViewController, title: String, message: String, dismissButtonTitle: String, okButtonTitle: String, dismissAction:@escaping ()-> Void, okAction:@escaping ()-> Void) {
        
        let validationLinkAlert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: dismissButtonTitle, style: UIAlertActionStyle.default) { (action) in
            dismissAction()
        }
        
        let okAction = UIAlertAction(title: okButtonTitle, style: UIAlertActionStyle.default) { (action) in
            okAction()
        }
        
        validationLinkAlert.addAction(dismissAction)
        validationLinkAlert.addAction(okAction)
        
        controller.present(validationLinkAlert, animated: true, completion: nil)
        
    }


}
