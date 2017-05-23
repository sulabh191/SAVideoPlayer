//
//  HomeWireFrame.swift
//  VideoAnalytics
//
//  Created by Sulabh Agarwal on 08/02/17.
//  Copyright © 2017 Sulabh. All rights reserved.
//

import UIKit

class HomeWireFrame: BaseWireFrame {

    func openVideoPlayer(_videoData:VideoModel) {
        let viewController = serviceLocator.provideVideoPlayerViewController()
        viewController.videoData = _videoData
        serviceLocator.navigatorContainer.resolve()?.pushViewController(viewController, animated: true)
    }
    
    func popToRootViewController () {
        serviceLocator.navigatorContainer.resolve()?.popToRootViewController(animated: true)
    }
}
