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
  func filtersViewController(filtersViewController :FiltersViewController, didUpdateFilters filters :[FilterRowIdentifier:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterTableViewCellDelegate, UINavigationBarDelegate, CellExpansionTapDelegate {

  @IBOutlet weak var filterTableView: UITableView!
  var filterValues :[FilterRowIdentifier:AnyObject]! = [:]
  var hasExpandedDistances = false
  var hasExpandedSorting = false
  var hasExpandedCategories = false
  let tableStructure: [FilterRowIdentifier] = [.Deals, .Distance, .SortBy, .Category]
  weak var delegate :FilterUpdateDelegate?
  
  func didTapCellExpansion(tableViewCell: UITableViewCell) {
    if tableViewCell is CenteredTableViewCell {
      hasExpandedCategories = true
    } else if tableViewCell is LabelImageTableViewCell {
      let indexPath = filterTableView.indexPathForCell(tableViewCell)
      if tableStructure[(indexPath?.section)!] == .Distance {
        if (hasExpandedDistances) {
          filterValues[.Distance] = filters.distanceOptions[indexPath!.row]
        }
        hasExpandedDistances = !hasExpandedDistances
      } else if tableStructure[(indexPath?.section)!] == .SortBy {
        if (hasExpandedSorting) {
          filterValues[.SortBy] = filters.sortByOptions[indexPath!.row]
        }
        hasExpandedSorting = !hasExpandedSorting
      }
    }
    filterTableView?.reloadData()
    
  }
  
  var filters: Filters! {
    didSet {
      filterValues[.Deals] = filters.deals
      filterValues[.Distance] = filters.distance
      filterValues[.SortBy] = filters.sortBy
      filterValues[.Category] = filters.categories
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
      filterTableView.registerNib(UINib(nibName: "LabelImageTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelImageTableViewCell")
        super.viewDidLoad()
      
      let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44)) // Offset by 20 pixels vertically to take the status bar into account
      
      navigationBar.barTintColor = UIColor.redColor()
      
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
      navigationBar.tintColor = UIColor.whiteColor()
      navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

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
    ret.distance = filterValues[.Distance] as! [[AnyObject]]
    ret.deals = filterValues[.Deals] as! Bool
    ret.sortBy = filterValues[.SortBy] as! String
    return ret
  }
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableStructure[section] {
    case .Category:
      return hasExpandedCategories ? filters.categoriesOptions.list.count : 4
    case .Deals:
      return 1
    case .Distance:
      return hasExpandedDistances ? filters.distanceOptions.count : 1
    case .SortBy:
      return hasExpandedSorting ? filters.sortByOptions.count : 1
    }
  }
  
  func cancelFilter() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func applyFilters() {
    delegate?.filtersViewController(self, didUpdateFilters: filterValues)
  }

  
  func filterTableViewCell(switchCell: FilterTableViewCell, didChangeValue value: Bool) {
    let indexPath = filterTableView.indexPathForCell(switchCell)
    
    switch tableStructure[(indexPath?.section)!] {
    case .Category:
      var categories = filterValues[.Category] as! Array<String>
      let selectedCategory = filters.categoriesOptions.list[(indexPath?.row)!]["code"] as! String
      
      if value {
        categories.append(selectedCategory)
      } else {
        categories = categories.filter({ $0 != selectedCategory })
      }
      
      filterValues[.Category] = categories
      
    case .Deals:
      filterValues[.Deals] = value
    default: break
    }
    filterTableView.reloadData()
  }
  
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if tableStructure[section] == .Deals {
      return ""
    }
    return tableStructure[section].rawValue
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    switch tableStructure[indexPath.section] {
    case .Category:
      let categories = filterValues[.Category] as! Array<String>
      let categoryNameInRow = filters.categoriesOptions.list[indexPath.row]["name"] as? String
      let categoryCodeInRow = filters.categoriesOptions.list[indexPath.row]["code"] as? String
      
      if hasExpandedCategories || indexPath.row <= 2 {
        let filterCell = tableView.dequeueReusableCellWithIdentifier("FilterTableViewCell", forIndexPath: indexPath) as! FilterTableViewCell
        filterCell.switchLabel.text = categoryNameInRow
        filterCell.filterSwitch.on = categories.contains(categoryCodeInRow!)
        filterCell.delegate = self
        return filterCell
      } else {
        let centeredCell = tableView.dequeueReusableCellWithIdentifier("CenteredTableViewCell", forIndexPath: indexPath) as! CenteredTableViewCell
        centeredCell.delegate = self
        return centeredCell
      }
      
    case .Deals:
      let filterCell = tableView.dequeueReusableCellWithIdentifier("FilterTableViewCell", forIndexPath: indexPath) as! FilterTableViewCell
      filterCell.filterSwitch.on = filterValues[.Deals] as! Bool
      filterCell.delegate = self
      filterCell.switchLabel.text = FilterRowIdentifier.Deals.rawValue
      return filterCell
    case .Distance:
      let labelImageCell = tableView.dequeueReusableCellWithIdentifier("LabelImageTableViewCell", forIndexPath: indexPath) as! LabelImageTableViewCell
      
      if (!hasExpandedDistances) {
        labelImageCell.imageTableCellImage.image = UIImage(named: "chevron_down")
        labelImageCell.imageTableCellLabel.text = filterValues[.Distance]![0] as! String
      } else {
        if filters.distanceOptions[indexPath.row][0] as! String == filterValues[.Distance]![0] as! String {
          labelImageCell.imageTableCellImage.image = UIImage(named: "yes_check")
        } else {
          labelImageCell.imageTableCellImage.image = UIImage(named: "circle_white")
        }
        labelImageCell.imageTableCellLabel.text = filters.distanceOptions[indexPath.row][0] as? String
      }
      labelImageCell.delegate = self
      return labelImageCell
    case .SortBy:
      let labelImageCell = tableView.dequeueReusableCellWithIdentifier("LabelImageTableViewCell", forIndexPath: indexPath) as! LabelImageTableViewCell
      
      if (!hasExpandedSorting) {
        labelImageCell.imageTableCellImage.image = UIImage(named: "chevron_down")
        labelImageCell.imageTableCellLabel.text = filterValues[.SortBy] as? String
      } else {
        if filterValues[.SortBy] as? String == filters.sortByOptions[indexPath.row] {
          labelImageCell.imageTableCellImage.image = UIImage(named: "yes_check")
        } else {
          labelImageCell.imageTableCellImage.image = UIImage(named: "circle_white")
        }
        labelImageCell.imageTableCellLabel.text = filters.sortByOptions[indexPath.row]
      }
      
      labelImageCell.delegate = self
      return labelImageCell
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
