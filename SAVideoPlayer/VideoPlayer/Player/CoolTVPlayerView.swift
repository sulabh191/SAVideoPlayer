//
//  CoolTVPlayerView.swift
//  CoolTV
//
//  Created by Sulabh Agarwal on 25/04/16.
//  Copyright © 2016 cooltv. All rights reserved.
//

import Foundation
import UIKit

protocol CoolTVPlayerViewDelegate {
    func playButtonTapped(_ sender: UIButton)
    func shrinkButtonTapped(_ sender: UIButton)
    func backButtonTapped()
    func fullScreenButtonTapped()
    func shareButtonTapped(_ sender: UIButton)
    func airPlayButtonTapped(_ sender: UIButton)
    func fadeInOutGestureTapped()
    func sliderBeganTracking(_ slider: UISlider!)
    func sliderEndedTracking(_ slider: UISlider!)
    func sliderValueChanged(_ slider: UISlider!)
}



class CoolTVPlayerView: UIView {
  
    //Vars
    var delegate:CoolTVPlayerViewDelegate?
    var isControlsHidden = false {
        didSet(newValue){
            //Log.Info("isControlsHidden changed from \(isControlsHidden) to \(newValue)")
            shouldHideUIControlObjects()
        }
    }
    
    var isPlayButtonHidden = false {
        didSet(newValue){

            shouldHideUIPlayButton()
        }
    }

    
    var alphaValue: CGFloat { if isControlsHidden { return 0 }
                            else {return 1} }
    var alphaValuePlayButtons: CGFloat { if isPlayButtonHidden { return 0 }
    else {return 1} }
    
    var tableView: UITableView  =   UITableView()
    


    //var videoOpenedFrom:VideoOpenedFrom?
    //var bufferingTimer: NSTimer?
    
    @IBOutlet weak var playButtoniPhone_Portrait: UIButton!
    @IBOutlet weak var playButtoniPhone_Landscape: UIButton!
    @IBOutlet weak var playButtoniPad: UIButton!
    @IBOutlet weak var playButton_mini_iPad: UIButton!
    @IBOutlet weak var shrinkButton: UIButton!
    @IBOutlet weak var shrinkButtoniPad: UIButton!
    @IBOutlet weak var airplayButton: UIButton!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var shareVideo: UIButton!
    @IBOutlet weak var shareVideoFullScreen: UIButton!
    @IBOutlet weak var shareVideoPortrait_iPad: UIButton!
    @IBOutlet weak var shareVideoLandscape_iPad: UIButton!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var playingOnRemoteLabel: UILabel!
    @IBOutlet weak var airPlayView: UIView!
    @IBOutlet weak var playerControlItemView: UIView!
    @IBOutlet weak var videoTitleTopConstraint_iPad: NSLayoutConstraint!
    @IBOutlet weak var videoTitleBottomConstraint_iPad: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressViewYConstraintiPad: NSLayoutConstraint!
    @IBOutlet weak var progressViewYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var videoTitleLeadingConstraint_iPad: NSLayoutConstraint!
    @IBOutlet weak var videoTitleLeadingConstraint_iPhone: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        playButtoniPhone_Portrait.setImage(UIImage(named: "icon_video_200"), for: .normal)
        playButtoniPhone_Landscape.setImage(UIImage(named: "icon_video_400"), for: .normal)
        playButtoniPad.setImage(UIImage(named: "icon_video_100"), for: .normal)
        
        playButtoniPhone_Portrait.setImage(UIImage(named: "icon_video_200_opacity_70"), for: .highlighted)
        playButtoniPhone_Landscape.setImage(UIImage(named: "icon_video_400_opacity_70"), for: .highlighted)
        playButtoniPad.setImage(UIImage(named: "icon_video_100_opacity_70"), for: .highlighted)

        shrinkButton.setImage(UIImage(named: "ic_minimize_video"), for: UIControlState())
        shrinkButton.setImage(UIImage(named: "ic_expand_video"), for:  UIControlState.selected)
        
        shrinkButtoniPad.setImage(UIImage(named: "ic_minimize_video"), for: UIControlState())
        shrinkButtoniPad.setImage(UIImage(named: "ic_expand_video"), for:  UIControlState.selected)
        
        playerSlider.addTarget(self, action: #selector(CoolTVPlayerView.sliderBeganTracking(_:)),
            for: UIControlEvents.touchDown)
        playerSlider.addTarget(self, action: #selector(CoolTVPlayerView.sliderEndedTracking(_:)),
            for: UIControlEvents.touchUpInside )
        playerSlider.addTarget(self, action: #selector(CoolTVPlayerView.sliderEndedTracking(_:)),
            for: UIControlEvents.touchUpOutside)
        playerSlider.addTarget(self, action: #selector(CoolTVPlayerView.sliderValueChanged(_:)),
            for: UIControlEvents.valueChanged)
        playerSlider.setThumbImage(UIImage(named:"ic_playhead_default"), for: UIControlState())

        shareVideoLandscape_iPad.isHidden = true
        shouldHideMiniPlayButtoniPad(true)
        backgroundColor = UIColor.clear
        addTapGesture()
        countDownLabel.isHidden = true
        //videoTitleTopConstraint_iPad.active = false
        //videoTitleBottomConstraint_iPad.constant = 6
        //
       // setVideoPlayerData()
        
        customizeProgressView()
    }
    
    //This class is used to get instance from Nib file
    fileprivate func instanceFromNib() -> CoolTVPlayerView {
        return Bundle.main.loadNib("CoolTVPlayerView", owner: self)
    }
    
    //
    func getCoolTVPlayerView(_ delegate:CoolTVPlayerViewDelegate) -> CoolTVPlayerView {
        
        let coolTVPlayerView = instanceFromNib()
        coolTVPlayerView.delegate = delegate
        return coolTVPlayerView
    }
    
    //MARK: Functions
    
    func setPlayButtonImageOnStateChange(_ state:PlayBack.PlaybackState) {
        var playButtonImage = "ic_pause_p_phone"
        var playButtonLandScapeImage = "ic_pause_l_phone"
        var playButtoniPadImage = "ic_pause_video_ipad.png"
        var playButtonImageHighlighted = "ic_pause_p_phone"
        var playButtonLandScapeImageHighlighted = "ic_pause_l_phone"
        var playButtoniPadImageHighlighted = "ic_pause_video_ipad.png"
        
        if state == PlayBack.PlaybackState.playing {
            playButtonImage = "ic_pause_p_phone"
            playButtonLandScapeImage = "ic_pause_l_phone"
            playButtoniPadImage = "ic_pause_video_ipad"
            playButtonImageHighlighted = "ic_pause_p_pressed_phone"
            playButtonLandScapeImageHighlighted = "ic_pause_l_pressed_phone"
            playButtoniPadImageHighlighted = "ic_pause_video_pressed_ipad"
            
        } else if state == PlayBack.PlaybackState.paused {
            playButtonImage = "icon_video_200.png"
            playButtonLandScapeImage = "icon_video_400"
            playButtoniPadImage = "icon_video_100"
            playButtonImageHighlighted = "icon_video_200_opacity_70"
            playButtonLandScapeImageHighlighted = "icon_video_400_opacity_70"
            playButtoniPadImageHighlighted = "icon_video_100_opacity_70"
            
        } else if state == PlayBack.PlaybackState.stopped {
            playButtonImage = "ic_replay_p_phone.png"
            playButtonLandScapeImage = "ic_replay_l_phone"
            playButtoniPadImage = "ic_replay_ipad"
            playButtonImageHighlighted = "ic_replay_p_pressed_phone"
            playButtonLandScapeImageHighlighted = "ic_replay_l_pressed_phone"
            playButtoniPadImageHighlighted = "ic_replay_pressed_ipad"
            
        } else if state == PlayBack.PlaybackState.unKnown {
            playButtonImage = ""
        }
        
        playButtoniPhone_Portrait.setImage(UIImage(named: playButtonImage), for: .normal)
        playButtoniPhone_Landscape.setImage(UIImage(named: playButtonLandScapeImage), for: .normal)
        playButtoniPad.setImage(UIImage(named: playButtoniPadImage), for: .normal)
        playButton_mini_iPad.setImage(UIImage(named: playButtonImage), for: .normal)
        
        playButtoniPhone_Portrait.setImage(UIImage(named: playButtonImageHighlighted), for: .highlighted)
        playButtoniPhone_Landscape.setImage(UIImage(named: playButtonLandScapeImageHighlighted), for: .highlighted)
        playButtoniPad.setImage(UIImage(named: playButtoniPadImageHighlighted), for: .highlighted)
        playButton_mini_iPad.setImage(UIImage(named: playButtonImageHighlighted), for: .highlighted)
        
    }
    


    
    /*func setVideoPlayerData(_ playerData:VideoPlayerData) {
        if let title = playerData.title {
            videoTitleLabel.text = title
        }
    }*/
    
    
    func addTapGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CoolTVPlayerView.fadeInOutGestureRecognizer))
        tapGesture.cancelsTouchesInView = true
        self.addGestureRecognizer(tapGesture)
    }
    
    func shouldHideMiniPlayButtoniPad(_ value:Bool) {
         playButton_mini_iPad.isHidden = value
    }
    
    /**
        This Function Hides/Unhides all UI controls (Except Play Button's)
     **/
    func shouldHideUIControlObjects() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
         
            //self.airplayButton.alpha = self.alphaValue
            self.fullScreenButton.alpha = self.alphaValue
            //self.shrinkButton.alpha = self.alphaValue
            self.playerSlider.alpha = self.alphaValue
            self.remainingTimeLabel.alpha = self.alphaValue
            self.totalDurationLabel.alpha = self.alphaValue
            self.shareVideo.alpha = self.alphaValue
            self.shareVideoFullScreen.alpha = self.alphaValue
            self.shareVideoPortrait_iPad.alpha = self.alphaValue
            self.shareVideoLandscape_iPad.alpha = self.alphaValue
            self.videoTitleLabel.alpha = self.alphaValue
            self.countDownLabel.alpha = self.alphaValue
            self.playingOnRemoteLabel.alpha = self.alphaValue
            self.airPlayView.alpha = self.alphaValue
            self.playerControlItemView.alpha = self.alphaValue
            if (self.alphaValue == 1) {
                self.backgroundColor  =  UIColor.black.withAlphaComponent(0.4)
            } else {
                 self.backgroundColor  = UIColor.clear
            }
        })
    }
    
    /**
     This Function Hides/Unhides  Play Button's
     **/
     func shouldHideUIPlayButton() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.playButtoniPhone_Portrait.alpha = self.alphaValuePlayButtons
            self.playButtoniPhone_Landscape.alpha = self.alphaValuePlayButtons
            self.playButton_mini_iPad.alpha = self.alphaValuePlayButtons
        })
    }
    
    func handleUIControlObjectsOnFullScreenButtonTap(_ isFullScreen:Bool) {
        if isFullScreen {
            //Handle UI for Landscape Mode
            //playListButton.hidden = false
            self.shrinkButton.isHidden = true
            self.shrinkButtoniPad.isHidden = true
            fullScreenButton.setImage(UIImage(named: "ic_exit_full_screen"), for: UIControlState())
            
            if(Helper.isDeviceIsPad()) {
                //Video Title
                videoTitleTopConstraint_iPad.isActive = true
                videoTitleTopConstraint_iPad.constant = 31
                videoTitleBottomConstraint_iPad.isActive = false
                //Share Button
                shareVideoPortrait_iPad.isHidden = true
                shareVideoLandscape_iPad.isHidden = false
                

            }
        } else {
            //Handle UI for Portrait Mode
            //playListButton.hidden = true

            self.shrinkButtoniPad.isHidden = false
            fullScreenButton.setImage(UIImage(named: "ic_full_screen_tablet"), for: UIControlState())
            if(Helper.isDeviceIsPad()) {
            //Video Title
            videoTitleTopConstraint_iPad.isActive = false
            videoTitleBottomConstraint_iPad.isActive = true
            videoTitleBottomConstraint_iPad.constant = 6
            //Share
            shareVideoPortrait_iPad.isHidden = false
            shareVideoLandscape_iPad.isHidden = true
            }
            shouldHidePlayListTableView(true)
        }

    }
    
    func customizeProgressView() {
        progressView.layer.cornerRadius = 2
        progressView.layer.masksToBounds = true
        
        // For iPad
        progressViewYConstraintiPad.constant = CGFloat(0.67)
        
        // For iPhone
        progressViewYConstraint.constant = CGFloat(0.67)
        
       // videoBufferTimer()
    }
    
    // MARK: Video Buffer Progress
    // Buffer Timer
    /*func videoBufferTimer() {
        bufferingTimer  = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateBufferingProgress), userInfo: nil, repeats: true)
    }*/
    
    // Update buffer progress view
    func updateBufferingProgress(_ availableDuration: Float64, totalDuration: Float64) {
        if progressView.progress < 1 {
            progressView.progress = Float(availableDuration/totalDuration)
        } else {
            // TODO: Invalidate timer on replay
            //bufferingTimer?.invalidate()
            print("Buffering Timer stopped")
        }
    }
    
    //MARK: TapGesture Handle
    
    func fadeInOutGestureRecognizer(){
        print("Tap Recognized in Player View")
        delegate?.fadeInOutGestureTapped()
    }
    
    
    func shouldHidePlayingOnRemoteView(_ value:Bool) {
         self.playingOnRemoteLabel.isHidden = value
    }
    
    func shouldHidePlayListTableView(_ value:Bool) {
        
        UIView.animate(withDuration: 0.25, animations: {
            let offset:CGFloat = value ? -320 : 0
             self.tableView.frame = CGRect( x: offset, y: 0, width: 320, height: self.frame.size.height)
            } , completion: { (finished) -> Void in
             self.tableView.isHidden = value
        })
        
       
    }
    
    
    //MARK: Button Actions
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        delegate?.playButtonTapped(sender)
    }
    
    @IBAction func playerShrinkButtonTapped(_ sender: UIButton) {
        delegate?.shrinkButtonTapped(sender)
    }
    
    @IBAction func fullScreenButtonTapped(_ sender: UIButton) {
        
        //self.fullScreenButton.selected = !self.fullScreenButton.selected
        //self.shrinkButton.hidden = !self.shrinkButton.hidden
        //handleUIControlObjectsOnFullScreenButtonTap()
        delegate?.fullScreenButtonTapped()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        delegate?.shareButtonTapped(sender)
    }
    
    @IBAction func chromecastButtonAction(_ sender: UIButton) {

    }
    
    @IBAction func airPlayButtonAction(_ sender: UIButton) {
        delegate?.airPlayButtonTapped(sender)
    }
    
    @IBAction func playListButtonAction(_ sender: UIButton) {
        shouldHidePlayListTableView(false)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        delegate?.backButtonTapped()
    }
    
    //MARK:Slider Actions
    func sliderBeganTracking(_ slider: UISlider!) {
        delegate?.sliderBeganTracking(slider)
    }
    
    func sliderEndedTracking(_ slider: UISlider!) {
        delegate?.sliderEndedTracking(slider)
        slider.setThumbImage(UIImage(named:"ic_playhead_default"), for: UIControlState())
    }
    
    func sliderValueChanged(_ slider: UISlider!) {
        delegate?.sliderValueChanged(slider)
        slider.setThumbImage(UIImage(named:"ic_playhead_pressed"), for: UIControlState())

    }
    
}

