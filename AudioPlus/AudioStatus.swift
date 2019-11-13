//
//  AudioStatus.swift
//  AudioPlus
//
//  Created by Shadrach Mensah on 13/11/2019.
//  Copyright © 2019 Shadrach Mensah. All rights reserved.
//

import Foundation




var appHasMicAccess = true

enum AudioStatus: Int, CustomStringConvertible {
  case Stopped = 0,
  Playing,
  Recording
  
  var audioName: String {
    let audioNames = [
      "Audio: Stopped",
      "Audio:Playing",
      "Audio:Recording"]
    return audioNames[rawValue]
  }
  
  var description: String {
    return audioName
  }
}
