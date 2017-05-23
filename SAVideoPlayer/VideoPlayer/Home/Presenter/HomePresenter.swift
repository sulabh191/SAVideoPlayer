//
//  HomePresenter.swift
//  VideoAnalytics
//

import UIKit

class HomePresenter: BasePresenter , HomeUIInterface{

    fileprivate weak var ui: HomeUI?
    fileprivate let wireframe: HomeWireFrame
    
    init(ui: HomeUI , wireframe:HomeWireFrame) {
        
        self.ui = ui
        self.wireframe = wireframe
    }

    
    
    
    func handleNext(videoData:VideoModel) {
        
        print("Cell Tapped")
        wireframe.openVideoPlayer(_videoData: videoData)
    }
    
    func getVideoList() {
        
        let inputData = VideoListInputParam(pageSize: 1, pageNumber: 1)
        getVideoList(inputData,success: { videoData in
            
            print(videoData)
            self.ui?.videoListFetchedSuccessfully(videoData)
            
        })


    }
    
    
    //MARK: Video List
    /**
     This function gets Video data from server
     
     - parameter videoListParam: Input parameters required for api
     - parameter success:            notify to user that data has been successfully fetched from the server with VideoModel
     - parameter failure:            notify to user the reason of failure
     */
    func getVideoList(_ videoListParam:VideoListInputParam,
                      success: @escaping (_ videoData: [VideoModel])-> Void) {
        
        do {
            if let file = Bundle.main.url(forResource: "VideoDetails", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print(object)
                    self.processVideoResponse(object as [String : AnyObject], successBlock: success)
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                   
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }

        
    }

    
    /**
     This function process the Video List response
     
     - parameter response:     response data from Get Video API
     - parameter successBlock: Success block with VideoModel
     */
    
    fileprivate func processVideoResponse(_ response: [String : AnyObject],
                                          successBlock: (_ videoData: [VideoModel])-> Void) {
        var videos = [VideoModel]()
        
        if (Helper.nullToNil(response[VideoParam.videos.rawValue]) != nil) {
            
            let videosArray = response[VideoParam.videos.rawValue] as! [[String: AnyObject]]
            
            for video in videosArray {
                let videoData = VideoModel(videoData: video)
                videos.append(videoData)
            }
            successBlock(videos)
        }
        
    }

    
    
    private func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "VideoDetails", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print(object)
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    

    
}
