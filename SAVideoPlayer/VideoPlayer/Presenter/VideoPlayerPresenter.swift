//
//  VideoPlayerPresenter.swift
//  VideoAnalytics
//
//  Created by Sulabh Agarwal on 09/02/17.
//  Copyright © 2017 Sulabh. All rights reserved.
//

import UIKit

class VideoPlayerPresenter: BasePresenter , VideoPlayerUIInterface {

    fileprivate weak var ui: VideoPlayerUI?
    
    init(ui: VideoPlayerUI ) {
        
        self.ui = ui
    }

    func playVideo() {
        
    }
    
    func storeVideoCurrentPosition(_ videoId:String , videoLength:Float64 , videoEvent:String?) {
        

    }
    
}


