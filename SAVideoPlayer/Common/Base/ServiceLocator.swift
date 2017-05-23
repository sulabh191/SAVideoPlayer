//
//  ServiceLocator.swift
//  VideoAnalytics
//
//  Created by Sulabh Agarwal on 06/02/17.
//  Copyright © 2017 Sulabh. All rights reserved.
//

import UIKit

class ServiceLocator {

    static let sharedInstance = ServiceLocator()
     let navigatorContainer = BaseNavigatorContainer()
    
    //MARK: Storyboards
    fileprivate func provideStoryboardWithName(_ storyBoardName: String) -> BaseStoryBoard {
        return BaseStoryBoard(name: storyBoardName)
    }
    
    //MARK: WireFrames 
    
   
    
    fileprivate func provideHomeWireFrame() -> HomeWireFrame {
        return HomeWireFrame()
    }
    
    //MARK:- VideoPlayer Controller
    func provideHomeViewController(_ window: UIWindow) -> HomeViewController {
        let homeViewController: HomeViewController = provideStoryboardWithName("HomeStoryboard").instantiateViewController("HomeViewController")
        let presenter =  HomePresenter(ui: homeViewController, wireframe: provideHomeWireFrame())
        homeViewController.presenter = presenter
        homeViewController.homeEventHandler = presenter
        
        //Set presenter to home view controller
        let nav = UINavigationController(rootViewController: homeViewController)
        let _ = self.navigatorContainer.register(nav)
        window.rootViewController = nav
        return homeViewController
    }
    

    
    
    //MARK:- VideoPlayer Controller
    func provideVideoPlayerViewController() -> VideoPlayerViewController {
        let videoPlayerViewController: VideoPlayerViewController = provideStoryboardWithName("PlayerStoryboard").instantiateViewController("VideoPlayerViewController")
        let presenter =  VideoPlayerPresenter(ui: videoPlayerViewController)
        videoPlayerViewController.presenter = presenter
        videoPlayerViewController.videoEventHandler = presenter
        return videoPlayerViewController
    }
    
}
