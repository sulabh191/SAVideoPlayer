//
//  InternetReachabilityManager.swift
//  CoolTV
//
//  Copyright © 2016 cooltv. All rights reserved.
//

import UIKit
import CoreTelephony

//Delegate for notifying about internet
protocol InternetReachabilityDelegate {
    
    func didRetry()
    func reachabilityDidChanged()
}

extension InternetReachabilityDelegate {
    
    func reachabilityDidChanged() {}
}

class InternetReachabilityManager: NSObject {
    
    //MARK: SharedInstance
    class var sharedInstance: InternetReachabilityManager {
        struct Singelton  {
            static var instance = InternetReachabilityManager()
        }
        return Singelton.instance
    }
    
    //declare this property where it won't go out of scope relative to your listener
    var delegate: InternetReachabilityDelegate?
    var reachability: Reachability?
    var alertController: UIAlertController?
    var isConnectedToInternet = true
    var isNetworkAlertVisible = false
    
    override init() {
        super.init()
        addNotifications()
    }
    
    deinit {
        removeNotifications()
        stopNotifier()
    }
    
    //MARK: Rechability Methods
    
    //this will start monitoring for network chnages.
    func startMonitoringForInternetReachability() {
        
       print("Started Monitoring for Internet Reachability")
        
        // Start reachability without a hostname intially
        setupReachability(hostName: nil)
        startNotifier()
        
        
        
    }
    
    func startNotifier() {
        
        print("--- start notifier")
        
        do {
            try reachability?.startNotifier()
        } catch {
            
            print("Unable to start\nnotifier")
            return
        }
    }
    
    func stopNotifier() {
        
        print("--- stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        reachability = nil
    }
    
    func setupReachability(hostName: String?) {
        
        print("--- set up with host name: \(hostName)")
        
        let reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        self.reachability = reachability
        
        NotificationCenter.default.addObserver(self, selector: #selector(InternetReachabilityManager.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
    }
    
    //this will be called when network changes will happen
    func reachabilityChanged(_ note: Notification) {
        
        print("Entry")
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            
            isConnectedToInternet = true
            
            dismissAlert()
            
            self.delegate?.didRetry()
            
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
            isConnectedToInternet = false
        }
        
        self.delegate?.reachabilityDidChanged()
        

    }
    
    // Function to stop monitoring network changes
    func stopMonitoringForInternetReachability() {
        
        
        if let _ = self.reachability {
            
            stopNotifier()
            
            print("Stopped Monitoring for Internet Reachability")
        }
        
     
        
    }
    
    //MARK: Internet Reachability Alert
    
    func showAlert(_ title:String?, message:String, okButtonTitle:String? , cancelButtonTitle:String?) {
        
      
        
        if let alertTiltle = title {
            print("Alert Tilte :  \(alertTiltle)")
            alertController = UIAlertController(title: alertTiltle, message:message, preferredStyle: .alert)
        } else {
            alertController = UIAlertController(title: nil, message:message, preferredStyle: .alert)
            print("No Alert Tilte")
        }
        
        
        if let okTitle = okButtonTitle {
            print("Has Ok action title : \(okTitle)")
            let okAction = UIAlertAction(title: okTitle, style: .default) { (action) -> Void in
                print("Choosed \(okTitle) action")
                
                // dismiss alert
                // self.dismissAlert()
                // call retry delegate
                self.isNetworkAlertVisible = false
                if let delegate = self.delegate {
                    delegate.didRetry()
                } else {
                    self.retry()
                }
                
            }
            
            alertController?.addAction(okAction)
        }
        
        
        if let cancelTitle = cancelButtonTitle {
            print("Has cancel action title : \(cancelTitle)")
            let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { (action) -> Void in
                
                self.isNetworkAlertVisible = false
                
                print("Choosed \(cancelTitle) action")
                
            }
            
            alertController?.addAction(cancelAction)
        }
        
        /*if let rootViewController = AppDelegate().delegate.window?.rootViewController {
            
            rootViewController.present(alertController!, animated: true, completion: { () -> Void in
                
                self.isNetworkAlertVisible = true
            })
            
        } else {
            
        }*/
  
        
    }
    
    //Auto dismiss alert
    func dismissAlert() {
        
        alertController?.dismiss(animated: true, completion: { () -> Void in
            
            self.isNetworkAlertVisible = false
            self.delegate = nil
        })
    }
    
    // Add Notification
    fileprivate func addNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(InternetReachabilityManager.applicationWillEnterForeground), name:NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    // Remove Notification
    fileprivate func removeNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        
    }
    
    //Application will enter in foreground
    func applicationWillEnterForeground() {
        
        
        retry()
        
   
    }
    
    // When user press retry to check interconnection
    fileprivate func retry() {
        
    
        
        if !isConnectedToInternet {
            
            showDismissibleAlert()
            
        } else {
            
            // Hide loader view if loading
            //AppDelegate().delegate.hideLoaderView()
        }
        
     
    }
    
    // fuctions to show dismissable pop up.
    func showDismissibleAlert() {
        
        if !isNetworkAlertVisible {
            
            //let translation = TranslationManager.sharedInstance
            
           // showAlert(translation.getStringForKey(TranslationEnums.NETWORK_ERROR.rawValue), message: translation.getStringForKey(TranslationEnums.OFFLINE_MODE_ERROR.rawValue), okButtonTitle: translation.getStringForKey(TranslationEnums.RETRY.rawValue), cancelButtonTitle: translation.getStringForKey(TranslationEnums.CANCEL.rawValue))
            
        }
        
    }
    
    func getCurrentNetworkType() -> String {
        if (self.reachability?.currentReachabilityStatus == Reachability.NetworkStatus.reachableViaWiFi){
            return "WIFi"
        }
        else if (self.reachability?.currentReachabilityStatus == Reachability.NetworkStatus.reachableViaWWAN){
            let telInfo = CTTelephonyNetworkInfo()
            if telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyLTE {
                return "4G"
            }else if telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyWCDMA || telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyHSDPA || telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyHSUPA {
                return "3G"
            }else if telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyGPRS || telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyEdge {
                return "2G"
            }
        }
        return "Not Connected"
    }
    
}
