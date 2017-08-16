# SAVideoPlayer
* Video Player using avplayer. This is sample project to play http url videos.

* class <b> VideoPlayer </b> : contains core avplayer functions , observers , Delegate CoolTVPlayerDelegate functions will be implemented in videoPlayerController.

* class <b> CustomVideoPlayer </b> : Is Inherited from VideoPlayer class , any custom features , functions will be added here.
overriding func playVideo() to pass video-url in CustomVideoPlayer.

* class <b> CoolTVPlayerView </b> : Is UIView which represents UI controls upon which user intended actions as play,pause,seek will be captured and will beimplemented via CoolTVPlayerViewDelegate into videoPlayerController
