//
//  BaseStoryBoard.swift
//  VideoAnalytics
//
//  Created by Sulabh Agarwal on 06/02/17.
//  Copyright © 2017 Sulabh. All rights reserved.
//

import Foundation
import UIKit

/*
 Provide a series of methods to help us to instantiate view controllers by there storyboard ID. By defaultinstantiateViewController() will search for view controller with the storyboard ID with the same name as the class
 */
public struct BaseStoryBoard {
    
    fileprivate let name: String
    
    // init
    public init(name: String) {
        self.name = name
    }
    
    // This function will load storyborad by there name
    fileprivate func storyboard(_ name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: Bundle.main)
    }
    
    // This function will load initial view controller from storyborad by storyboard name
    fileprivate func initialViewController<T>() -> T {
        let uiStoryboard = storyboard(name)
        return uiStoryboard.instantiateInitialViewController() as! T
    }
    
    // This function will load view controller by identifier name
    public func instantiateViewController<T>(_ viewControllerIdentifier: String) -> T {
        let uiStoryboard = storyboard(name)
        return uiStoryboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as! T
    }
    
    // This function will initiate a view controller default viewcontroller class name will be passes as view controller idetifier
    public func instantiateViewController<T>() -> T {
        return instantiateViewController(String(describing: T.self))
    }
    
}
