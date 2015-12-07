//
//  FeedViewCell.swift
//  Density
//
//  Created by Matt on 12/1/15.
//  Copyright © 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

let feedViewVerticalPadding: CGFloat = 40.0
let feedViewProgressHeight: CGFloat = 6.0
let feedViewLeftRightPadding: CGFloat = 20.0
let capacityScalingFactor: CGFloat = 3.0
let mainTopPadding: CGFloat = 10.0
let mainBottomPadding: CGFloat = 20.0
let floorTopPadding: CGFloat = 4.0
let floorBottomPadding: CGFloat = 8.0
let mainMiddlePaddingOffset: CGFloat = 10.0
let floorMiddlePaddingOffset: CGFloat = 5.0
let normalLeftPadding: CGFloat = 10.0
let indentLeftPadding: CGFloat = 30.0

class FeedViewCell: UICollectionViewCell {
  @IBOutlet var locationName: UILabel!
  @IBOutlet var capacityIndicator: UIProgressView!
  @IBOutlet var expandIcon: UIImageView!
  @IBOutlet var capacityLabel: UILabel!
  @IBOutlet var locationNameLeftConstraint: NSLayoutConstraint!
  @IBOutlet var locationNameTopPaddingConstraint: NSLayoutConstraint!
  @IBOutlet var capacityIndicatorBottomPaddingConstraint: NSLayoutConstraint!
  @IBOutlet var locationNameBottomPadding: NSLayoutConstraint!

  static let reuseIdentifier = "FeedViewCell"

  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  class func heightForCell(model: LocationModel) -> CGFloat {
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    // TODO: This will look bad with long names on small screens. Maybe fix this.
    let sampleLocationLabel: UILabel = UILabel(frame: CGRectMake(0, 0, screenWidth - feedViewLeftRightPadding, 0))
    sampleLocationLabel.text = model.name
    sampleLocationLabel.font = DefaultFont
    sampleLocationLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
    sampleLocationLabel.numberOfLines = 0
    sampleLocationLabel.sizeToFit()
    
    var verticalPadding = feedViewVerticalPadding
    if model.isFloor {
      verticalPadding -= (mainTopPadding - floorTopPadding) + (mainBottomPadding - floorBottomPadding)
      verticalPadding -= (mainMiddlePaddingOffset - floorMiddlePaddingOffset)
    }
    
    return sampleLocationLabel.frame.size.height + verticalPadding + feedViewProgressHeight
  }
  
  func inflate(model: LocationModel) {
    locationName.text = model.name
    capacityLabel.text = formatCapacityLabel(model.percentFull)
    capacityLabel.hidden = model.isMultiFloor
    expandIcon.hidden = !model.isMultiFloor
    capacityIndicator.progress = model.percentFull!
    locationNameTopPaddingConstraint.constant = model.isFloor ? floorTopPadding : mainTopPadding
    capacityIndicatorBottomPaddingConstraint.constant = model.isFloor ? floorBottomPadding : mainBottomPadding
    locationNameBottomPadding.constant = model.isFloor ? floorMiddlePaddingOffset : mainMiddlePaddingOffset
    layoutIfNeeded()
    expandIcon.image = !model.selected ? UIImage(named: "ExpandArrow") : UIImage(named: "CollapseArrow")
    if model.isFloor {
      backgroundColor = Colors.LightGrey
    } else {
      backgroundColor = UIColor.whiteColor()
    }
  }
  
  func formatCapacityLabel(capacity: Float?) -> String {
    if capacity != nil {
      var roundCapacity: Int = Int(capacity! * 100)
      if roundCapacity > 100 {
        roundCapacity = 100
      }
      return String(roundCapacity) + "%"
    } else {
      // If we don't get a capacity, fair to say capacity is zero.
      return "0%"
    }
  }
  
  func setup() {
    backgroundColor = UIColor.whiteColor()
    locationName.font = DefaultFont
    capacityLabel.font = LightFont
    capacityIndicator.transform = CGAffineTransformScale(capacityIndicator.transform, 1, capacityScalingFactor)
    capacityIndicator.progressTintColor = Colors.Progress
    capacityIndicator.trackTintColor = Colors.LightGrey
    locationName.adjustsFontSizeToFitWidth = false
  }

}
