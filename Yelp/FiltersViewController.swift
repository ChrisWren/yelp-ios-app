//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Chris Wren on 5/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit


enum FilterRowIdentifier : String {
  case Deals = "Offering a Deal"
  case Distance = "Distance"
  case SortBy = "Sort By"
  case Category = "Category"
}

protocol FilterUpdateDelegate: class {
  func filtersViewController(filtersViewController :FiltersViewController, didUpdateFilters filters :[String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterTableViewCellDelegate, UINavigationBarDelegate, CellExpansionTapDelegate {

  @IBOutlet weak var filterTableView: UITableView!
  var filterValues :[FilterRowIdentifier:AnyObject]! = [:]
  var hasExpandedCategories = false
  let tableStructure: [FilterRowIdentifier] = [.Deals, .Distance, .SortBy, .Category]
  weak var delegate :FilterUpdateDelegate?
  
  func didTapCellExpansion(centeredTableViewCell: CenteredTableViewCell) {
    hasExpandedCategories = true
    filterTableView.reloadData()
  }
  
  var currentFilters: Filters! {
    didSet {
      filterValues[.Deals] = currentFilters.deals
      filterValues[.Distance] = currentFilters.distance
      filterValues[.SortBy] = currentFilters.sortBy
      filterValues[.Category] = currentFilters.categories
      filterTableView?.reloadData()
    }
  }
  
    override func viewDidLoad() {
        filterTableView.delegate = self
        filterTableView.dataSource = self
      
      filterTableView.rowHeight = UITableViewAutomaticDimension
      filterTableView.estimatedRowHeight = 90
      filterTableView.registerNib(UINib(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterTableViewCell")
      filterTableView.registerNib(UINib(nibName: "CenteredTableViewCell", bundle: nil), forCellReuseIdentifier: "CenteredTableViewCell")
        super.viewDidLoad()
      
      let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44)) // Offset by 20 pixels vertically to take the status bar into account
      
      navigationBar.barTintColor = UIColor.redColor()
      navigationBar.tintColor = UIColor.whiteColor()
      navigationBar.delegate = self
      
      // Create a navigation item with a title
      let navigationItem = UINavigationItem()
      navigationItem.title = "Filters"
      
      // Create left and right button for navigation item
      let leftButton =  UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(cancelFilter))
      let rightButton = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(applyFilters))
      
      // Create two buttons for the navigation item
      navigationItem.leftBarButtonItem = leftButton
      navigationItem.rightBarButtonItem = rightButton
      
      // Assign the navigation item to the navigation bar
      navigationBar.items = [navigationItem]
      
      // Make the navigation bar a subview of the current view controller
      self.view.addSubview(navigationBar)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return tableStructure.count
  }
  
  func fitlersFromTableData() -> Filters {
    let ret = Filters()
    ret.categories = filterValues[.Category] as! Array<String>
    ret.distance = filterValues[.Distance] as! String
    ret.deals = filterValues[.Deals] as! Bool
    ret.sortBy = filterValues[.SortBy] as! String
    return ret
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableStructure[section] {
    case .Category:
      return hasExpandedCategories ? filterValues[.Category]!.count : 4
    case .Deals:
      return 1
    case .Distance:
      return 1
    case .SortBy:
      return 1
    }
  }
  
  func cancelFilter() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func applyFilters() {
//    tableStructure[]
  }

  
//  func filterTableViewCell(switchCell: FilterTableViewCell, didChangeValue value: Bool) {
//    let indexPath = filterTableView.indexPathForCell(switchCell)
//    
//  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if tableStructure[section] == .Deals {
      return ""
    }
    return tableStructure[section].rawValue
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    switch tableStructure[indexPath.section] {
    case .Category:
      if hasExpandedCategories || indexPath.row <= 2 {
        let filterCell = tableView.dequeueReusableCellWithIdentifier("FilterTableViewCell", forIndexPath: indexPath) as! FilterTableViewCell
        filterCell.switchLabel.text = currentFilters.categoriesOptions.list[indexPath.row]["name"] as! String
        filterCell.delegate = self
        return filterCell
      } else {
        var centeredCell = tableView.dequeueReusableCellWithIdentifier("CenteredTableViewCell", forIndexPath: indexPath) as! CenteredTableViewCell
        centeredCell.delegate = self
        return centeredCell
      }
      
    case .Deals:
      let filterCell = tableView.dequeueReusableCellWithIdentifier("FilterTableViewCell", forIndexPath: indexPath) as! FilterTableViewCell
      filterCell.filterSwitch.on = filterValues[.Deals] as! Bool
      filterCell.switchLabel.text = FilterRowIdentifier.Deals.rawValue
      return filterCell
//    case .Distance:
////      return 1
//    case .SortBy:
////      return 1
    default:
      return tableView.dequeueReusableCellWithIdentifier("FilterTableViewCell", forIndexPath: indexPath)
    }
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
