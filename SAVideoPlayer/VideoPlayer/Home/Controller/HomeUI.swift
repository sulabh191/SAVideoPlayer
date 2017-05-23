//
//  HomeUI.swift
//  VideoAnalytics
//
//

import Foundation


public protocol HomeUIInterface {
    
    func handleNext(videoData:VideoModel)
    
    func getVideoList()
    
}

public protocol HomeUI: BaseProtocolUI {
    
    func videoListFetchedSuccessfully(_ videoList : [VideoModel])
}
