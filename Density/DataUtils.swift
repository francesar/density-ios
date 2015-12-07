//
//  DataUtils.swift
//  Density
//
//  Created by Matt on 12/1/15.
//  Copyright © 2015 Matthew Piccolella. All rights reserved.
//

import Foundation


func getAuthorizedLink() -> String {
  return Density.URL + urlAction() + "?" + Density.AuthParam + "=" + Density.Key
}

func urlAction() -> String {
  // TODO: Probably change this - we likely don't always want latest
  return "latest"
}

func processMapping(locationData: [LocationModel]) -> ([LocationModel], Dictionary<String,[LocationModel]>) {
  var locationMapping: Dictionary<String,[LocationModel]> = Dictionary()
  var locationList: [LocationModel] = []
  
  // Gotta calculate frequencies for libraries first, a little inconvenient.
  var locationFrequency: Dictionary<String, (Int, Float)> = Dictionary()
  for location in locationData {
    let locationArr: [String] = location.name!.componentsSeparatedByString(" ")
    if Int(locationArr.last!) != nil || locationArr.last! == "stk" {
      let libraryName = locationArr[0...locationArr.count-2].joinWithSeparator(" ")
      if let (currentCount, currentFreq) = locationFrequency[libraryName] {
        let percent = location.percentFull! > 1.0 ? 1.0 : location.percentFull!
        locationFrequency[libraryName] = (currentCount + 1, currentFreq + percent)
      } else {
        locationFrequency[libraryName] = (1, location.percentFull!)
      }
    }
  }

  // Then, go through and divide into libraries
  for location in locationData {
    let locationArr: [String] = location.name!.componentsSeparatedByString(" ")
    if Int(locationArr.last!) != nil || locationArr.last! == "stk" {
      let libraryName = locationArr[0...locationArr.count-2].joinWithSeparator(" ")
      if var _ = locationMapping[libraryName] {
        if Int(locationArr.last!) != 301 {
          location.name = "Floor " + locationArr.last!
        } else {
          location.name = "Reference Room"
        }
        location.isFloor = true
        locationMapping[libraryName]! += [location]
      } else {
        if Int(locationArr.last!) != 301 {
          location.name = "Floor " + locationArr.last!
        } else {
          location.name = "Reference Room"
        }
        location.isFloor = true
        locationMapping[libraryName] = [location]
        let (count, capacity) = locationFrequency[libraryName]!
        locationList.append(LocationModel(name: libraryName, capacity: (capacity / Float(count))))
      }

      // TODO: Don't hard-code this. It seems ill-advised to do so.
      if locationArr.last! == "stk" {
        location.name = "Stacks"
      }
    } else {
      locationList.append(location)
    }
  }
  
  return (locationList, locationMapping)
}