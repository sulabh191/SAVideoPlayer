//
//  VideoPlayerViewController.swift
//  Created by Sulabh Agarwal on 08/02/17.
//

import UIKit

class VideoPlayerViewController: BaseViewController ,VideoPlayerUI {

   
    var videoEventHandler : VideoPlayerUIInterface!
    var videoData:VideoModel?
    var player:CustomVideoPlayer?
    var coolTVPlayerView:CoolTVPlayerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.viewWillLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.player?.playerWillDisAppear()
        self.player?.destroyPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
         super.viewWillLayoutSubviews()
        
         self.player?.layoutSubViews(view)
    }
    
    func playVideo () {
        
        if (self.player == nil) {
            self.player = CustomVideoPlayer(delegate: self)
  
            self.coolTVPlayerView = CoolTVPlayerView().getCoolTVPlayerView(self)
            self.coolTVPlayerView?.frame = self.view.frame
 
            self.view .addSubview((self.coolTVPlayerView)!)
            self.view.clipsToBounds = true

            
        }
        if (self.player?.avPlayer == nil) {
            self.player!.setUpVideoPlayer(self.view)
        }
        if let videoURl = self.videoData?.videoUrl {
            self.player?.playVideo(videoURl)
        }
    }

    

}

extension VideoPlayerViewController : CoolTVPlayerDelegate {
    
    func playerPlaybackDidEnd(_ player:VideoPlayer) {
        
    }
    func replayVideoTapped() {
        
    }
    
    func playBackStateDidChange(_ playBackState:PlayBack.PlaybackState , currentDuration: Float64) {
        
         self.coolTVPlayerView?.setPlayButtonImageOnStateChange(playBackState)
        
    }
    func updatePlayerSlider(_ elapsedTime: Float64, duration: Float64) {
        
        let progress =  elapsedTime / duration
        self.coolTVPlayerView?.playerSlider.setValue(Float(progress), animated: false)
        
    }
    func updatePlayerTimer(_ elapsedTime: Float64, duration: Float64) {
        
        //let timeRemaining: Float64 = duration - elapsedTime
        self.coolTVPlayerView?.remainingTimeLabel.text = String(format: "%02d:%02d", ((lround(elapsedTime) / 60) % 60), lround(elapsedTime) % 60)
        
        self.coolTVPlayerView?.totalDurationLabel.text = String(format: "%02d:%02d", ((lround(duration) / 60) % 60), lround(duration) % 60)
        
    }
    func updatePlayerCurrentTime(_ currentDuration: Float64 , videoEvent:String?) {
        
        if let videoId = self.videoData?.videoId {
         videoEventHandler?.storeVideoCurrentPosition(videoId, videoLength: currentDuration,videoEvent: videoEvent)
        }
        
    }

    func updateBufferingProgress(_ availableDuration: Float64, totalDuration: Float64) {
        
    }
    
    func showPlayBackErrorView() {
        
    }
    func removePlayBackErrorView() {
        
    }
    
}

//MARK: CoolTVPlayerViewDelegate functions
extension VideoPlayerViewController : CoolTVPlayerViewDelegate {
   
    func backButtonTapped() {
        
    }

    
    func playButtonTapped(_ sender: UIButton) {
        
        self.player?.playButtonTapped(sender)
  
        
    }
    
    func shrinkButtonTapped(_ sender: UIButton) {
      
    }
    
    func shareButtonTapped(_ sender: UIButton) {
       
    }
    
    func fullScreenButtonTapped() {
        
    }
    
    func airPlayButtonTapped(_ sender: UIButton) {
        
        //AirPlay.startMonitoring(self.coolTVPlayerView!)
        //registerForAirPlayAvailabilityChanges()
        
    }

    
    func fadeInOutGestureTapped() {
        
    }
    
    
    //MARK:Slider Delegate Function
    /**
     Function call when slider begin sliding.
     
     - parameter slider: current slider object
     */
    func sliderBeganTracking(_ slider: UISlider!) {
         self.player?.sliderBeganTracking(slider)
    }
    
    /**
     Function call when slider end sliding.
     - parameter slider: current slider object
     */
    func sliderEndedTracking(_ slider: UISlider!) {
        self.player?.sliderEndedTracking(slider)

    }
    
    func sliderValueChanged(_ slider: UISlider!) {
         self.player?.sliderValueChanged(slider)
    }
    
}

