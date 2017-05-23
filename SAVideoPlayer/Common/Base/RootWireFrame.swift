//
//  RootWireFrame.swift
//  VideoAnalytics
//

import UIKit

class RootWireFrame: BaseWireFrame {

    // This function will present home view controller and this will be our root view controller after splash.
    func presentLoginViewControllerInWindow(_ window: UIWindow) {
        let _ = serviceLocator.provideHomeViewController(window)
        //window.rootViewController = viewController
    }
    
}
