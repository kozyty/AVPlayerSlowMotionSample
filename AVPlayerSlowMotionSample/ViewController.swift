//
//  ViewController.swift
//  AVPlayerSlowMotionSample
//
//  Created by Taiyo Kojima on 2016/12/03.
//  Copyright © 2016年 Taiyo Kojima. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
  
  @IBOutlet weak var seekBar: UISlider!
  @IBOutlet weak var videoPlayerView: AVPlayerView!
  @IBOutlet weak var slowButton: UIButton!
  @IBOutlet weak var playButton: UIButton!
  
  private var playerItem: AVPlayerItem? = nil
  private var videoPlayer: AVPlayer? = nil
  private var videoTimeObserver: Any? = nil
  private var playingRateAfterScrub: Float = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let path = "https://github.com/kozyty/AVPlayerSlowMotionSample/blob/master/slowmotion_ios.MOV?raw=true"
    guard let url = URL(string: path) else { return }
    self.playerItem = AVPlayerItem(url: url)
    self.videoPlayer = AVPlayer(playerItem: playerItem)
    
    guard let videoPlayer = self.videoPlayer else { return }
    videoPlayerView.setPlayer(player: videoPlayer)
    videoPlayerView.setVideoFillMode(fillMode: AVLayerVideoGravityResizeAspect)
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: self.playerItem)
    
    guard let time = videoPlayer.currentItem?.asset.duration else { return }
    self.videoTimeObserver = videoPlayer.addPeriodicTimeObserver(forInterval: time, queue: DispatchQueue.main, using: { [unowned self](CMTime) in
      self.syncSeekber()
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func playOrPause(_ sender: Any) {
    if self.isPlaying() {
      self.pause()
    } else {
      self.play()
    }
  }
  
  @IBAction func touchDownSlowButton(_ sender: Any) {
    if self.isPlaying() {
      self.slow()
    }
  }
  
  @IBAction func touchUpSlowButton(_ sender: Any) {
    if self.isPlaying() {
      self.play()
    } else {
      self.pause()
    }
  }
  
  // MARK: - Player Notifications
  
  func playerItemDidReachEnd(notification: NSNotification) {
    self.seekToTime(position: 0)
  }
  
  
  // MARK: - Player Item
  
  func isPlaying() -> Bool {
    return playingRateAfterScrub != 0 || self.videoPlayer!.rate != 0
  }
  
  func playerItemDuration() -> CMTime {
    let playerItem: AVPlayerItem = self.videoPlayer!.currentItem!
    if playerItem.status == .readyToPlay {
      return playerItem.duration
    }
    
    return kCMTimeInvalid
  }
  
  
  // MARK: - Player Appearance
  
  func syncSeekber() {
    let playerDuration: CMTime = self.playerItemDuration()
    
    if !playerDuration.isValid {
      self.seekBar.minimumValue = 0
      return
    }
    
    let duration: Double = CMTimeGetSeconds(playerDuration)
    let currentTime: Double = CMTimeGetSeconds(self.videoPlayer!.currentTime())
    
    let progress: Float = Float(currentTime/duration)
    self.seekBar.setValue(progress, animated: true)
  }
  
  // MARK: - Play & Pause
  
  func play() {
    self.videoPlayer!.automaticallyWaitsToMinimizeStalling = true
    self.videoPlayer!.play()
  }
  
  func pause() {
    self.videoPlayer!.pause()
  }
  
  func slow() {
    self.videoPlayer!.automaticallyWaitsToMinimizeStalling = false
    self.videoPlayer!.setRate(0.0001, time: kCMTimeInvalid, atHostTime: kCMTimeInvalid)
  }
  
  func isScrubbing() -> Bool {
    return playingRateAfterScrub != 0;
  }
  
  func seekToTime(position: Double) {
    let playerDuration: CMTime = self.playerItemDuration()
    
    if !playerDuration.isValid {
      self.seekBar.minimumValue = 0
      return
    }
    
    let duration: Double  = CMTimeGetSeconds(playerDuration);
    
    let currentTime: Double = CMTimeGetSeconds(videoPlayer!.currentTime())
    if (currentTime <= 0 && position == 0) || (currentTime >= duration && position == 1) {
      return;
    }
    
    let time: Double = duration * position
    self.videoPlayer!.seek(to: CMTimeMakeWithSeconds(time, Int32(NSEC_PER_SEC)))
  }
}
