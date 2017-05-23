//
//  VideoEnum.swift
//  VideoAnalytics
//
//  Created by Sulabh on 2/9/17.
//  Copyright © 2017 Sulabh. All rights reserved.
//

import Foundation

public enum VideoListInputParams: String {
    case pageSize = "ps"
    case pageNumber = "pn"
}

// MARK: Video Param
public enum VideoParam: String {
    case videoId = "video_id"
    case title = "title"
    case video_url = "video_url"
    case tv_rating = "tv_rating"
    case video_length = "video_length"
    case thumnail_url = "thumnail_url"
    case description = "description"
    case videos = "videos"
}

//Project VideoEntitlement  API Parameter

public enum VideoEntitlementInputParam: String {
    
    case videoId =  "video_id"
    case userId =  "user_id"
    case platform =  "platform"
    case deviceType = "device_type"
    case networkType = "network_type"
    case longitude = "longitude"
    case latitude = "latitude"
    case shareToken = "share_token"
    case deviceId = "device_id"
    
    //extra Enum for Hear Beat
    case videoLength = "video_length"
    case videoEvent = "event"
}

public enum PlatFormEnums : String {
    
    case uid = "uid"
    case platFormOS = "platform_os"
    case user_agent          = "user_agent"
    case device_type         = "device_type"
    case platform_os_version = "platform_os_version"
    case device_model        = "device_model"
}
