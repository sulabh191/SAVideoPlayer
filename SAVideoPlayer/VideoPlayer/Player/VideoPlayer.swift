
//  VideoPlayer.swift
//  Created by Sulabh Agarwal on 08/02/17.
//

import UIKit
import AVKit
import AVFoundation

protocol CoolTVPlayerDelegate {
    
    func playerPlaybackDidEnd(_ player:VideoPlayer)
    func replayVideoTapped()
    
    func playBackStateDidChange(_ playBackState:PlayBack.PlaybackState , currentDuration: Float64)
    func updatePlayerSlider(_ elapsedTime: Float64, duration: Float64)
    func updatePlayerTimer(_ elapsedTime: Float64, duration: Float64)
    func updatePlayerCurrentTime(_ currentDuration: Float64 , videoEvent:String?)

    func updateBufferingProgress(_ availableDuration: Float64, totalDuration: Float64)
    
    func showPlayBackErrorView()
    func removePlayBackErrorView()
}


open class PlayBack : NSObject {
    
    @objc //  mark enum with @objc
    public enum PlaybackState: Int, CustomStringConvertible {
        case stopped
        case playing
        case paused
        case buffering
        case failed
        case loaded
        case unKnown
        
        public  var description: String {
            get {
                switch self {
                case .stopped:
                    return "Stopped"
                case .playing:
                    return "Playing"
                case .failed:
                    return "Failed"
                case .paused:
                    return "Paused"
                case .buffering:
                    return "Buffering"
                case .loaded:
                    return "Loaded"
                case .unKnown:
                    return "UnKnown"
                }
            }
        }
    }
    
    dynamic var state = PlaybackState.unKnown
    
}


class VideoPlayer: NSObject {

    
    var _playback:PlayBack!
    fileprivate let KeyPlayBackState = "state"
    fileprivate let PlayerEmptyBufferKey = "playbackBufferEmpty"
    fileprivate let KeyPlayBackLikelyToKeep =  "playbackLikelyToKeepUp"
    fileprivate let KeyLoadItemRanges =  "loadedTimeRanges"
    //var coolTVPlayerView:CoolTVPlayerView?
    var avPlayer: AVPlayer!
    fileprivate var playerItem: AVPlayerItem?
    var avPlayerLayer: AVPlayerLayer!
    var isPlaying =  true
    var playerRateBeforeSeek: Float = 0
    var previousPlaybackTime:TimeInterval = 0
    var timeObserver: AnyObject!
    var isFullScreen = false
    var portraitFrame:CGRect!
    var landscapeFrame: CGRect!
    var delegate:CoolTVPlayerDelegate?
    
    var loaderView:LoaderView?
    
    var playbackLikelyToKeepUpContext = 0
    fileprivate var PlayerItemObserverContext = 0
    
    
    fileprivate var progessPercentage = 10
    
   
    
    //Background Thread - QOS
    let qualityOfServiceClass = DispatchQoS.QoSClass.background
    //Internet Reachability
    fileprivate var internetReachability = InternetReachabilityManager.sharedInstance
    
    //MARK:
    
    init(delegate:CoolTVPlayerDelegate) {
        
        super.init()
        
        _playback = PlayBack()
        initializeProperties()
        self.delegate = delegate
        //internetReachability.delegate = self
        //self.coolTVPlayerView = CoolTVPlayerView().getCoolTVPlayerView(self)

        
    }
    
    func initializeProperties() {
        
        let bounds = UIScreen.main.bounds
        
        portraitFrame = CGRect(x: 0, y: 0, width: min(bounds.size.width, bounds.size.height), height: max(bounds.size.width, bounds.size.height));
        landscapeFrame = CGRect(x: 0, y: 0, width: max(bounds.size.width, bounds.size.height), height: min(bounds.size.width, bounds.size.height));
        
        _playback.addObserver(self, forKeyPath:KeyPlayBackState, options: NSKeyValueObservingOptions.initial, context: nil)
        _playback.state = .unKnown
    }
    
       

    
    /**
     Player Wrappers
     **/
    
    func pauseVideoPlayer() {
        if (avPlayer != nil) {
            avPlayer.pause()
            _playback.state = .paused
            
        }
    }
    
    
    func resumeVideoPlayer() {
        
        if (avPlayer != nil)  {
            self.avPlayer.play()
            _playback.state = .playing
        }
    }
    
    func stop() {
        if _playback.state == PlayBack.PlaybackState.stopped {
            return
        }
        _playback.state = .stopped
    }
    
    func seekToPosition(_ position:Double) {
        let targetTime = CMTimeMakeWithSeconds(position, 10)
        self.avPlayer.seek(to: targetTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        
    }
    
    func playVideo(_ urlString:String,watchTick:Double = 0.0) {

        if let url = URL(string:urlString) {
            _playback.state = .unKnown
            let avUrlAsset = AVURLAsset(url: url)
            let keys = ["playable"]
            
            removeObserverOnPlayerItem()
            
            self.playerItem = nil
            self.playerItem = AVPlayerItem(asset: avUrlAsset)
            
            addObserverOnPlayerItem()
            //Set Default position of UISlider:
            //TODO: Set Slider position from watchTick
            //coolTVPlayerView?.playerSlider.setValue(0.0, animated: false)
            
            avUrlAsset.loadValuesAsynchronously(forKeys: keys) { () -> Void in
                
                do {
                    if let avPlayer = self.avPlayer {
                        avPlayer.replaceCurrentItem(with: self.playerItem)
                        //avPlayer.play()
                        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                        try AVAudioSession.sharedInstance().setActive(true)
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            self.delegate?.playBackStateDidChange(PlayBack.PlaybackState.loaded, currentDuration: 0.0)
                            
                            self.resumeVideoPlayer()
                            
                        })
                    }
                    
                } catch {
                    print(error)
                }
                
            }
        }
    }
    
    /**
     Function Will Add Observer on PlayerItem i.e any change observed in playbackLikelyToKeepUpContext ,PlayBackBuffer .
     */
    fileprivate func addObserverOnPlayerItem() {
        
        if let playerItem = self.playerItem {
            
            playerItem.addObserver(self, forKeyPath: KeyPlayBackLikelyToKeep,
                                   options: NSKeyValueObservingOptions.new, context: &playbackLikelyToKeepUpContext)
            playerItem.addObserver(self, forKeyPath: PlayerEmptyBufferKey, options: NSKeyValueObservingOptions.new, context: &PlayerItemObserverContext)
            playerItem.addObserver(self, forKeyPath: KeyLoadItemRanges, options: NSKeyValueObservingOptions.new, context: &PlayerItemObserverContext)
            
            /*NotificationCenter.default.addObserver(self, selector: #selector(CoolTVPlayer.playerDidFinishPlaying(_:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)*/
        }
        
    }
    
    fileprivate func removeObserverOnPlayerItem() {
        
        if let playerItem = self.playerItem {
            
            playerItem.removeObserver(self, forKeyPath: KeyPlayBackLikelyToKeep)
            playerItem.removeObserver(self, forKeyPath: PlayerEmptyBufferKey)
            playerItem.removeObserver(self, forKeyPath: KeyLoadItemRanges)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            
        }
    }
    
    /**
     Function to destroy video player.
     */
    func destroyPlayer() {
        
        if (avPlayer != nil) {
            print("DESTROYING PLAYER")
            avPlayer.removeTimeObserver(timeObserver)
            removeObserverOnPlayerItem()
            self.avPlayer = nil
            self.playerItem = nil
            self.avPlayerLayer.removeFromSuperlayer()
            self.avPlayerLayer = nil
        }
        
        

    }
    

    func isPlayingVideo() -> Bool {

        if (self.avPlayer != nil) {
            return avPlayer.rate != 0.0
        } else { return  false }
    }
    
    
    //MARK: Setup video Player
    /**
     Function for Setup video Player
     
     - parameter urlString: url string for streaming
     */
    func setUpVideoPlayer (_ view:UIView) {
        
        // An AVPlayerLayer is a CALayer instance to which the AVPlayer can
        // direct its visual output. Without it, the user will see nothing.
        avPlayer = AVPlayer()
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.frame = view.frame
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        
        //Adding Loading Indicator
        if loaderView == nil {
            loaderView = LoaderView(viewFrame: view.frame)
        }
        
        view.addSubview(loaderView!)
        loaderView!.startAnimating(.black)
        
        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
        timeObserver = avPlayer.addPeriodicTimeObserver(forInterval: timeInterval,
                                                        queue: DispatchQueue.main) { (elapsedTime: CMTime) -> Void in
                                                            // NSLog("elapsedTime now %f", CMTimeGetSeconds(elapsedTime));
                                                            self.observeTime(elapsedTime)
            } as AnyObject!
        
       
        
    }
    
    /**
     Key value observers for player
     
     - parameter keyPath: value for a key event that will be monitored
     - parameter object: player object
     - parameter change: change value
     - parameter context: context value
     */
    override internal func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (avPlayer != nil) {
            if (avPlayer.error != nil) {
                self.hideLoaderView()
                _playback.state = .failed
                return
            }
        }
        
        switch (keyPath) {
        case (.some(KeyPlayBackState)):
            print("Observed state change to \(_playback.state)")
            
            self.delegate?.playBackStateDidChange(_playback.state,currentDuration: self.currentElapsedTime())
            //coolTVPlayerView?.setPlayButtonImageOnStateChange(_playback.state)
            
        case (.some(KeyPlayBackLikelyToKeep)):
            if (avPlayer != nil) {
                if let avPlayerItem = avPlayer.currentItem {
                    if (avPlayerItem.isPlaybackLikelyToKeepUp) {
                        if  avPlayer.rate > 0.0 {
                            _playback.state = .playing
                        } else {
                            
                            if _playback.state != PlayBack.PlaybackState.paused {
                                _playback.state = .paused
                            }
                            
                        }
                        self.hideLoaderView()
                    } else {
                        //Check If Internet is available
                        if internetReachability.isConnectedToInternet {
                            self.showLoaderView()
                        }
                    }
                } else {
                    self.hideLoaderView()
                }
            }
            
        case (.some(PlayerEmptyBufferKey)):
            if let item = self.playerItem {
                if (internetReachability.isConnectedToInternet)  {
                    print("PlayerEmptyBufferKey -isConnectedToInternet")
                    //shouldRemovePlayBackErrorView()
                    if item.isPlaybackBufferEmpty {
                        //Buffering
                        print("Handle Buffering - Show Loader")
                        self.showLoaderView()
                        self.pauseVideoPlayer()
                        //_playback.state = .UnKnown
                    } else {
                        print("Handle Buffering - Hide Loader")
                        self.hideLoaderView()
                        self.resumeVideoPlayer()
                    }
                } else {
                    print("PlayerEmptyBufferKey -  Not ConnectedToInternet")
                    //shouldDisplayPlayBackErrorView()
                }
            }
            
        case (.some(KeyLoadItemRanges)):
            //Calculating timeDuration available to play Video
            if let item = self.playerItem {
                let result = availableDurationToPlay(item)
                let duration = CMTimeGetSeconds(item.duration)
                self.delegate?.updateBufferingProgress(result, totalDuration: duration)
                // Log.Info("AvailableDuration: \(result)")
                
            }
            
        default:
            break
        }
        
    }
    
    /**
     Function To calculate available(Buffered) Video Duration to Play
     
     - parameter AVPlayerItem: current player item
     **/
    func availableDurationToPlay(_ item:AVPlayerItem) -> Float64 {
        
        /*var times = item.loadedTimeRanges as [NSValue]
         let timeRange : CMTimeRange = times[0].CMTimeRangeValue
         let startSeconds = CMTimeGetSeconds(timeRange.start)
         let durationSeconds = CMTimeGetSeconds(timeRange.duration)
         return startSeconds + durationSeconds*/
        let range = item.loadedTimeRanges.first
        if (range != nil){
            return CMTimeGetSeconds(CMTimeRangeGetEnd(range!.timeRangeValue))
        }
        return 0
        
    }
    
    
       
    ///******************observeTime*************//
    
    //MARK: observeTimer  call Back
    /**
     Function for observing video playback time
     
     - parameter elapsedTime: The total time elapse by the player
     */
    fileprivate func observeTime(_ elapsedTime: CMTime) {
        //Added Validation to see if player screen is visible on controller , if not make it pause
       // if (self.isViewPresented || AirPlay.isConnected) {
            
            let duration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
            if (duration.isFinite) {
                
                let elapsedTime = CMTimeGetSeconds(elapsedTime)
                self.delegate?.updatePlayerTimer(elapsedTime,duration: duration)
                self.delegate?.updatePlayerSlider(elapsedTime,duration: duration)
                self.observePeriodicPlayBackTime(elapsedTime, duration: duration)
            }
            
       // }
    }
    
    //
    func observePeriodicPlayBackTime (_ elapsedTime: Float64 , duration: Float64) {
        
        
    }

    /**
     NSNotification Observer CallBack  when videoPlayer has finished played Video , if so we change the playbackState to Stopped
     */
    func playerDidFinishPlaying(_ note: Notification) {
        self.stop()

    }
    

    
    /**
     Shows loader view in screen
     */
    fileprivate func showLoaderView() {
        
        if loaderView != nil {
            loaderView!.startRotating()
            loaderView?.isHidden = false
        }
    }
    
    /**
     Hides loader view in screen
     */
    func hideLoaderView() {
        
        if loaderView != nil {
            loaderView!.stopRotating()
            loaderView?.isHidden = true
            //loaderView!.removeFromSuperview()
        }
    }
    
    fileprivate func runAfterDelay(_ delay: TimeInterval, block: @escaping ()->()) {
        let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: block)
    }
    
    fileprivate func currentElapsedTime() -> Float64 {
        
        if (avPlayer != nil) {
            return CMTimeGetSeconds(self.avPlayer.currentTime())
        }
        
        return 0
    }
}
