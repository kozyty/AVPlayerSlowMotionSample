//
//  AVPlayerView.swift
//  AVPlayerSlowMotionSample
//
//  Created by Taiyo Kojima on 2016/12/03.
//  Copyright © 2016年 Taiyo Kojima. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerView: UIView {
  
  override class var layerClass: AnyClass {
    return AVPlayerLayer.self
  }
  
  func player() -> AVPlayer {
    let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
    return layer.player!
  }
  
  func setPlayer(player: AVPlayer) {
    let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
    layer.player = player
  }
  
  func setVideoFillMode(fillMode: String) {
    let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
    layer.videoGravity = fillMode
  }
  
  func videoFillMode() -> String {
    let layer: AVPlayerLayer = self.layer as! AVPlayerLayer
    return layer.videoGravity
  }
}
