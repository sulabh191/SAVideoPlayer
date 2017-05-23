//
//  BaseWireFrame.swift
//  VideoAnalytics
//
//

import Foundation

//This is base class all wireframe classes need to inherrited from this, wire frame is responsible for navigation across various screens. It also has the common service Locator object so child wire frame has access to service loactor object.

class BaseWireFrame {
    
    var serviceLocator: ServiceLocator {
        return ServiceLocator.sharedInstance
    }
}
