//
//  VideoListModel.swift
//  VideoAnalytics
//
//  Created by Sulabh on 2/9/17.
//  Copyright © 2017 Sulabh. All rights reserved.
//

import Foundation

struct VideoListInputParam {
    var pageSize : Int
    var pageNumber : Int
    
    init(pageSize:Int = 0, pageNumber:Int = 0) {
        
        self.pageSize = pageSize
        self.pageNumber = pageNumber
    }
    
}

// This class is responsible for initializing Video model
open class VideoModel {
    //MARK: Variables
    var videoId: String?
    var videoTitle: String?
    var videoTvRating: String?
    var videoLength: String?
    var videoUrl: String?
    var videoThumnailUrl: String?
    var videoDescription: String?
    
    
    /**
     Initialize module
     
     - parameter response: video model data in the form of dictionary coming from get video API
     
     */
    init(videoData: [String: AnyObject]) {
        if (Helper.nullToNil(videoData[VideoParam.videoId.rawValue]) != nil) {
            self.videoId = videoData[VideoParam.videoId.rawValue] as? String
        }
        
        if (Helper.nullToNil(videoData[VideoParam.title.rawValue]) != nil) {
            self.videoTitle = videoData[VideoParam.title.rawValue] as? String
        }
        
        if (Helper.nullToNil(videoData[VideoParam.description.rawValue]) != nil) {
            self.videoDescription = videoData[VideoParam.description.rawValue] as? String
        }
               
        if (Helper.nullToNil(videoData[VideoParam.video_url.rawValue]) != nil) {
            self.videoUrl = "http://www.streambox.fr/playlists/x36xhzz/x36xhzz.m3u8"//videoData[VideoParam.video_url.rawValue] as? String
        }
        
        if (Helper.nullToNil(videoData[VideoParam.video_length.rawValue]) != nil) {
            self.videoLength = videoData[VideoParam.video_length.rawValue] as? String
        }
        
        if (Helper.nullToNil(videoData[VideoParam.thumnail_url.rawValue]) != nil) {
            self.videoThumnailUrl = videoData[VideoParam.thumnail_url.rawValue] as? String
        }
        
        if (Helper.nullToNil(videoData[VideoParam.tv_rating.rawValue]) != nil) {
            self.videoTvRating = videoData[VideoParam.tv_rating.rawValue] as? String
        }
    }
}
