//
//  BaseNavigatorContainer.swift
//  VideoAnalytics
//

import UIKit

open class BaseNavigatorContainer {
    
    fileprivate var container: [String : UINavigationController] = [ : ]
    
    public init() {
    }
    
    // This function will add the root navigation view in navigation controller
    open func register<T: UINavigationController>(_ navigationController: T) -> T {
        
        let navColor = UIColor(colorLiteralRed: 22.0/255, green: 22.0/255, blue: 23.0/255, alpha: 1.0)
        navigationController.navigationBar.barTintColor = navColor
      //  navigationController.navigationBar.setBackgroundImage(Helper.getImageWithColor(navColor, size: navigationController.navigationBar.frame.size),  for: .default)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        container[String(describing: T.self)] = navigationController
        
        return navigationController
    }
    
    // This function will return the  navigation view controller.
    open func resolve<T: UINavigationController>() -> T? {
        
        return (container[String(describing: T.self)] as! T)
    }
}
