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
  
  var feedData: [JSON] = []
  var refreshControl: UIRefreshControl!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Setup and start loader views
    overlayView.backgroundColor = Colors.LightGrey
    updateLoaderViews(true)
    
    fetchData(getAuthorizedLink(), completion: {[weak self] () in
      self?.collectionView.reloadData()
      self?.updateLoaderViews(true)
    })
  }

  func setupCollectionView() {
    collectionView.backgroundColor = UIColor.whiteColor()
    collectionView.dataSource = self
    collectionView.delegate = self
    // TODO: Register cell.
    //collectionView.registerNib(UINib(nibName: "StreamItemCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: StreamItemCell.reuseIdentifier)
    collectionView.bounces = true
    collectionView.alwaysBounceVertical = true
    
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "refreshStreamItems", forControlEvents: .ValueChanged)
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
          self.feedData = responseData["data"].array!
          completion()
        case .Failure(let error):
          print(error)
          // TODO: Do actual error handling.
      }
    }
  }
}

extension FeedViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    // TODO: Implement.
  }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    // TODO: Implement.
  }
}


extension FeedViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    // TODO: Implement.
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.feedData.count
  }
}
