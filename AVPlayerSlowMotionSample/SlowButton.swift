//
//  SlowButton.swift
//  AVPlayerSlowMotionSample
//
//  Created by Taiyo Kojima on 2016/12/05.
//  Copyright © 2016年 Taiyo Kojima. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SlowButton : UIButton {
  private var videoPlayer: AVPlayer? = nil
  
  func configure(_ videoPlayer: AVPlayer) {
    self.videoPlayer = videoPlayer
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches{
//      guard let pressure = (touch.force/touch.maximumPossibleForce) as CGFloat? else { return }
//      print("% Touch pressure: \(pressure)");
//      if (pressure == 1.0) {
//        self.pause()
//      } else {
//        self.slow()
//      }
      print("% Touch major: \(touch.majorRadius)")
      if (touch.majorRadius > 60.0) {
        print("Touch pause")
        self.pause()
      } else {
        print("Touch slow")
        self.slow()
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    print("Touches End")
    self.play()
  }
  
  private func play() {
    print("play")
    self.videoPlayer!.automaticallyWaitsToMinimizeStalling = false
    self.videoPlayer!.setRate(2.0, time: kCMTimeInvalid, atHostTime: kCMTimeInvalid)
  }
  
  private func pause() {
    print("pause")
    self.videoPlayer!.pause()
  }
  
  private func slow() {
    print("pause")
    self.videoPlayer!.automaticallyWaitsToMinimizeStalling = false
    self.videoPlayer!.setRate(0.5, time: kCMTimeInvalid, atHostTime: kCMTimeInvalid)
  }
  
  private func isPlaying() -> Bool {
    return self.videoPlayer!.rate != 0
  }
}
