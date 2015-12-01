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