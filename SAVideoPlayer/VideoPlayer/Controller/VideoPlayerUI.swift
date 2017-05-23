//
//  VideoPlayerUI.swift
//  VideoAnalytics
//
//  Created by Sulabh Agarwal on 09/02/17.
//  Copyright © 2017 Sulabh. All rights reserved.
//

import Foundation


public protocol VideoPlayerUIInterface {
    
    func playVideo()
    
    func storeVideoCurrentPosition(_ videoId:String , videoLength:Float64 , videoEvent:String?)
}

public protocol VideoPlayerUI: BaseProtocolUI {
    
}
