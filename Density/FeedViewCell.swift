//
//  FeedViewCell.swift
//  Density
//
//  Created by Matt on 12/1/15.
//  Copyright © 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

let feedViewVerticalPadding: CGFloat = 50.0
let feedViewProgressHeight: CGFloat = 2.0
let feedViewLeftRightPadding: CGFloat = 20.0

class FeedViewCell: UICollectionViewCell {
  @IBOutlet var locationName: UILabel!
  @IBOutlet var capacityIndicator: UIProgressView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  class func heightForCell(title: String) -> CGFloat {
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    let sampleLocationLabel: UILabel = UILabel(frame: CGRectMake(0, 0, screenWidth - feedViewLeftRightPadding, 0))
    sampleLocationLabel.text = title
    // TODO: Style this.
    // sampleLocationLabel.font =
    sampleLocationLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
    sampleLocationLabel.numberOfLines = 0
    sampleLocationLabel.sizeToFit()
    
    return sampleLocationLabel.frame.size.height + feedViewVerticalPadding + feedViewProgressHeight
  }

}
