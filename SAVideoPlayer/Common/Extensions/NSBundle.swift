//
//  NSBundle.swift
//  VideoAnalytics
//
//  Created by Sulabh Agarwal on 22/02/17.
//  Copyright © 2017 Sulabh. All rights reserved.
//

import Foundation

import UIKit

//MARK: Public Extenssion to NSBundle for loading custom views from bundle.
extension Bundle {
    
    var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
    
    var appTargetName: String? {
        return self.infoDictionary?["CFBundleName"] as? String
    }
    
    //Load views from bundle with owner
    public func loadNib<T: UIView>(_ name: String, owner: AnyObject?) -> T {
        return self.loadNibNamed(name, owner: owner, options: nil)![0] as! T
    }
    
    //Load views from bundle without passing owner
    public func loadNib<T: UIView>(_ name: String) -> T {
        return self.loadNibNamed(name, owner: nil, options: nil)![0] as! T
    }
    
    
}

