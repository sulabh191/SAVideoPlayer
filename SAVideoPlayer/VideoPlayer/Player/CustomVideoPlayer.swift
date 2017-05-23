//
//  customVideoPlayer.swift
//
//  Created by Sulabh Agarwal on 10/02/17.
//

import UIKit
import AVKit
import AVFoundation

class CustomVideoPlayer: VideoPlayer {

    //MARK: Variables
    
     var isViewPresented = true
     fileprivate var lastPlayingTimeForHearBeat:Float64 = 0
     let timeIntervalToStoreVideoLength = 10.0
    
    //MARK: override player functions
    override init(delegate: CoolTVPlayerDelegate) {
        
        super.init(delegate: delegate)
        
        NotificationCenter.default.addObserver(self, selector:#selector(UIApplicationDelegate.applicationWillResignActive(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object:UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: UIApplication.shared)
    }
    
    override func setUpVideoPlayer(_ view: UIView) {
        super.setUpVideoPlayer(view)
        
    }
    
    override func playVideo(_ urlString: String, watchTick: Double = 0.0) {
        
        super.playVideo(urlString,watchTick : watchTick)
    }
    
    override func destroyPlayer() {
        super.destroyPlayer()
        
        removeNotifications()
    }
    
    //Function will get invoke automatically when changes in playback time
    override func observePeriodicPlayBackTime(_ elapsedTime: Float64, duration: Float64) {
        print("observePeriodicPlayBackTime")
        storeCurrentVideoLength()
        
        let accessLog = self.avPlayer.currentItem?.accessLog()
        if let event = accessLog?.events , event.count > 0 {
            let eventObject = event[0]
            print("Event:Indicated Bit rate \(eventObject.indicatedBitrate)")
            print("Event:Observed Bit rate \(eventObject.observedBitrate)")
        }
        
        
    }
    
    
    //MARK: private func
    fileprivate func removeNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    /**
     Function to Update Player Current Time,
     Used to HIT Video Heart Beat API
     */
    fileprivate func storeCurrentVideoLength() {
        
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: { [unowned self] in
            if(self.avPlayer != nil) {
                
                self.calculateTimeForHearBeat()
                
            }
        })
    }
    
    fileprivate func calculateTimeForHearBeat() {
        let currentTimeAbs = CMTimeGetSeconds(self.avPlayer.currentTime())
        //Reset last Playing time to currentime , if user has moved scrubber backwards
        if(currentTimeAbs < self.lastPlayingTimeForHearBeat) {
            self.lastPlayingTimeForHearBeat = currentTimeAbs
        }
        //Validating if difference b/w current time and lastTime when video heartBeat requested  is greater then "timeIntervalToStoreVideoLength"
        if (currentTimeAbs - self.lastPlayingTimeForHearBeat > timeIntervalToStoreVideoLength) {
            //Update Player Current Duration Time
            self.lastPlayingTimeForHearBeat = currentTimeAbs
            print("Update Player lastPlayingTime: \(self.lastPlayingTimeForHearBeat)")
            self.delegate?.updatePlayerCurrentTime(currentTimeAbs,videoEvent: nil)
        }
        
    }


    /**
     View Cycle Functions :
     **/
    
    func playerWillAppear() {
        isViewPresented = true
        if (super.avPlayer != nil) {
            switch super._playback.state {
            case .playing:
                self.resumeVideoPlayer()
            case .paused:
                self.pauseVideoPlayer()
            case .stopped:
                stop()
                
            default :
                break
            }
            
        }
    }
    
    func playerWillDisAppear() {
        isViewPresented = false
        if (super.avPlayer != nil) {
            switch super._playback.state {
            case .playing:
                self.pauseVideoPlayer()
            default :
                break
            }
            super.hideLoaderView()
        }
    }

    
    func layoutSubViews(_ view:UIView) {
        
        if (super.avPlayer != nil) {
            super.avPlayerLayer.frame = view.bounds
        }
        if let loaderView = self.loaderView {
            loaderView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        }
    }
    
    ///******************Application Notifications*************//
    //MARK: App State Notifications
    
    func applicationWillResignActive(_ aNotification: Notification) {
        
    }
    
    func applicationDidEnterBackground(_ aNotification: Notification) {
        
    }
    
    func applicationWillEnterForeground(_ aNoticiation: Notification) {
        /*if self.playbackState == .Paused {
         self.resumeVideoPlayer()
         }*/
    }

    
}

//MARK: Extension
extension CustomVideoPlayer {
    
    func playButtonTapped(_ sender: UIButton) {
        
        switch (_playback.state) {
        case .paused  :
            self.resumeVideoPlayer()
        //sendDataForHeartBeat(nil)
        case .playing :
            self.pauseVideoPlayer()
            //hidePlayerControlsWhenPaused()
            
        default :
            break
            
        }
    }
    
    
    //MARK:Slider Delegate Function
    /**
     Function call when slider begin sliding.
     
     - parameter slider: current slider object
     */
    func sliderBeganTracking(_ slider: UISlider!) {
        playerRateBeforeSeek = avPlayer.rate
        pauseVideoPlayer()
    }
    
    /**
     Function call when slider end sliding.
     - parameter slider: current slider object
     */
    func sliderEndedTracking(_ slider: UISlider!) {
        if let duration = self.avPlayer.currentItem?.duration {
            let videoDuration = CMTimeGetSeconds(duration)
            let elapsedTime: Float64 = videoDuration * Float64(slider.value)
            self.delegate?.updatePlayerTimer(elapsedTime,duration: videoDuration)
            
            avPlayer.seek(to: CMTimeMakeWithSeconds(elapsedTime, 10), completionHandler: { (completed: Bool) -> Void in
                //self.sendDataForHeartBeat(nil)
                if (self.playerRateBeforeSeek > 0) {
                    self.resumeVideoPlayer()
                }
            })
        }
    }
    
    func sliderValueChanged(_ slider: UISlider!) {
        if let duration = self.avPlayer.currentItem?.duration {
            let videoDuration = CMTimeGetSeconds(duration)
            let elapsedTime: Float64 = videoDuration * Float64(slider.value)
            self.delegate?.updatePlayerTimer(elapsedTime,duration: videoDuration)
        }
    }

    func getWidthOfVideo() -> Float {
        return Float(avPlayerLayer.videoRect.width)
    }
    
    func getHeightOfVideo() -> Float {
        return Float(avPlayerLayer.videoRect.height)
    }
}

