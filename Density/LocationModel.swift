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
  var isMultiFloor: Bool = false
  var selected: Bool = false
  
  init(json: JSON) {
    name = json["group_name"].string
    if let percent = json["percent_full"].float {
      percentFull = percent / 100.0
    } else {
      percentFull = 0.0
    }
  }
  
  init(name: String, capacity: Float, isMultiFloor: Bool = true) {
    self.name = name
    self.isMultiFloor = isMultiFloor
    self.percentFull = capacity
  }
}