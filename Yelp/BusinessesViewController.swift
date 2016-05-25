//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Chris Wren on 5/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FilterUpdateDelegate {

  var businesses: [Business]?
  var searchBar: UISearchBar?
  @IBOutlet weak var businessTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    businessTableView.delegate = self
    businessTableView.dataSource = self
    businessTableView.rowHeight = UITableViewAutomaticDimension
    businessTableView.estimatedRowHeight = 90
    businessTableView.registerNib(UINib(nibName: "BusinessTableViewCell", bundle: nil), forCellReuseIdentifier: "BusinessTableViewCell")
    
    fetchBusinesses("Restaurants")
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .Plain, target: self, action: #selector(showFilterView))
    navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    self.searchBar = UISearchBar()
    self.searchBar?.sizeToFit()
    self.searchBar?.delegate = self
    self.searchBar?.placeholder = "Restaurants"
    navigationItem.titleView = searchBar
  }
  
  func showFilterView () {
    searchBar?.resignFirstResponder()
    let filtersVc = FiltersViewController()
    filtersVc.delegate = self
    filtersVc.currentFilters = Filters()
    
    self.presentViewController(filtersVc, animated: true, completion: nil)
  }
  
  func fetchBusinesses (query :String) {
    Business.searchWithTerm(query, sort: .Distance, categories: [], deals: false) { (businesses: [Business]!, error: NSError!) -> Void in
      self.businesses = businesses
      self.businessTableView.reloadData()
      self.searchBar?.resignFirstResponder()
    }
  }
  
  func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
    fetchBusinesses("Restaurants")
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    fetchBusinesses(searchBar.text!)
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return businesses?.count ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("BusinessTableViewCell", forIndexPath: indexPath) as! BusinessTableViewCell
    if let business = businesses![indexPath.row] as Business? {
      fetchImage(cell.businessImage, businessImageURL: business.imageURL)
      fetchImage(cell.starsImageView, businessImageURL: business.ratingImageURL)
      cell.addressLabel.text = business.address
      cell.reviewsLabel.text = String(business.reviewCount! ?? 0) + " Reviews"
      cell.addressLabel.text = business.address
      cell.categoriesLabel.text = business.categories
      cell.businessName.text = business.name
      cell.distanceLabel.text = business.distance
    }
    return cell
  }
  
  func fetchImage(imageView: UIImageView, businessImageURL: NSURL?) {
    
    let imageRequest = NSURLRequest(URL: businessImageURL!)
    
    imageView.setImageWithURLRequest(
      imageRequest,
      placeholderImage: nil,
      success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
        
        // smallImageResponse will be nil if the smallImage is already available
        // in cache (might want to do something smarter in that case).
        
        if smallImageResponse == nil {
          imageView.alpha = 0.0
        }
        imageView.image = smallImage;
        
        let duration = smallImageResponse != nil ? 0.3 : 0
        
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
          
          imageView.alpha = 1.0
          
          }, completion: nil)
      },
      failure: { (request, response, error) -> Void in
        print("Failure")
        // do something for the failure condition
        // possibly try to get the large image
    })
    
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
