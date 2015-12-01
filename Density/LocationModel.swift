//
//  LocationModel.swift
//  Density
//
//  Created by Matt on 12/1/15.
//  Copyright © 2015 Matthew Piccolella. All rights reserved.
//

import Foundation
import SwiftyJSON

class LocationModel {
  var name: String?
  var percentFull: Float? = 0.0
  
  init(json: JSON) {
    name = json["group_name"].string
    if let percent = json["percent_full"].float {
      percentFull = percent / 100.0
    } else {
      percentFull = 0.0
    }
  }
}