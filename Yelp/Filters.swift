//
//  Filters.swift
//  Yelp
//
//  Created by Chris Wren on 5/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//
import UIKit

class Filters: NSObject {
  var deals :Bool = false
  var distanceOptions :[[AnyObject]] = [
    ["Auto", 0],
    ["0.3 Miles", 482.803],
    ["1 Mile", 1609.34],
    ["5 Miles", 8046.72],
    ["20 Miles", 329916]
  ]
  var distance = ["Auto", 0]
  var sortByOptions = ["Best Match", "Distance", "Highest Rated"]
  var sortBy = "Best Match"
  var categories :Array<String> = []
  var categoriesOptions = Categories()
}
