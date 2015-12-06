//
//  FeedViewController.swift
//  Density
//
//  Created by Matt on 12/1/15.
//  Copyright © 2015 Matthew Piccolella. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FeedViewController: UIViewController {

  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  @IBOutlet var overlayView: UIView!
  
  var feedData: [LocationModel] = []
  var libraryMapping: Dictionary<String,[LocationModel]> = Dictionary()
  var refreshControl: UIRefreshControl!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Setup and start loader views
    overlayView.backgroundColor = Colors.LightGrey
    activityIndicator.hidesWhenStopped = true
    updateLoaderViews(true)
    
    setupViews()
    
    fetchData(getAuthorizedLink(), completion: {[weak self] () in
      self?.collectionView.reloadData()
      self?.updateLoaderViews(true)
    })
  }
  
  func setupViews() {
    // Set color/title on the navigation bar
    self.navigationController?.navigationBar.barTintColor = Colors.Blue

    // Set the center logo
    let navImage = UIImageView(frame: TitleImageFrame)
    navImage.image = UIImage(named: "density-logo.png")!
    let imageView = UIImageView(frame: TitleImageFrame)
    imageView.addSubview(navImage)
    self.navigationItem.titleView = imageView
    
    print(UIFont.fontNamesForFamilyName("Lato"))

    setupCollectionView()
  }

  func setupCollectionView() {
    collectionView.backgroundColor = Colors.LightGrey
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.registerNib(UINib(nibName: "FeedViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: FeedViewCell.reuseIdentifier)
    collectionView.bounces = true
    collectionView.alwaysBounceVertical = true
    
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "refreshLocations", forControlEvents: .ValueChanged)
    collectionView.addSubview(refreshControl)
  }
  
  func updateLoaderViews(hidden: Bool) {
    overlayView.hidden = hidden
    if hidden {
      activityIndicator.stopAnimating()
    } else {
      activityIndicator.startAnimating()
    }
  }
  
  func fetchData(url: String, completion: () -> Void) {
    Alamofire.request(.GET, url, encoding: .JSON).responseData { response in
      switch response.result {
        case .Success(_):
          let responseData: JSON = JSON(data: response.data!)
          if let locations = responseData["data"].array {
            let remoteData = locations.map({ (json: JSON) -> LocationModel in
              LocationModel(json: json)
            })
            let (libraryList, libraryMapping) = processMapping(remoteData)
            self.feedData = libraryList
            self.libraryMapping = libraryMapping
          }
          completion()
        case .Failure(let error):
          print(error)
          // TODO: Do actual error handling.
      }
    }
  }
  
  func refreshLocations() {
    fetchData(getAuthorizedLink(), completion: { [weak self] in
      self?.collectionView.reloadData()
      self?.refreshControl.endRefreshing()
    })
  }
  
  func collapseLibraryCells(selectedLocationName: String, index: Int) {
    let numberOfFloors = libraryMapping[selectedLocationName]!.count
    let begin = index+1
    feedData.removeRange(begin...begin+numberOfFloors-1)
  }
}

extension FeedViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let selectedLocation = feedData[indexPath.row]
    if selectedLocation.isMultiFloor {
      if selectedLocation.selected {
        collapseLibraryCells(selectedLocation.name!, index: indexPath.row)
        selectedLocation.selected = false
        collectionView.reloadData()
      } else {
        print("Should be expanding")
        feedData.insertContentsOf(libraryMapping[selectedLocation.name!]!, at: indexPath.row + 1)
        selectedLocation.selected = true
        collectionView.reloadData()
      }
    }
  }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let model: LocationModel = feedData[indexPath.row]
    let cellHeight: CGFloat = FeedViewCell.heightForCell(model)
    return CGSizeMake(self.view.frame.size.width, cellHeight)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 5.0
  }
}


extension FeedViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let feedViewCell: FeedViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(FeedViewCell.reuseIdentifier, forIndexPath: indexPath) as! FeedViewCell
    feedViewCell.inflate(feedData[indexPath.row])
    return feedViewCell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.feedData.count
  }
}
