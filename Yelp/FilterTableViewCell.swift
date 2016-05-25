//
//  FilterTableViewCell.swift
//  Yelp
//
//  Created by Chris Wren on 5/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterTableViewCellDelegate {
  optional func filterTableViewCell(switchCell :FilterTableViewCell, didChangeValue value: Bool)
}

class FilterTableViewCell: UITableViewCell {

  @IBOutlet weak var switchLabel: UILabel!
  @IBOutlet weak var filterSwitch: UISwitch!
  
  weak var delegate :FilterTableViewCellDelegate?
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        filterSwitch.addTarget(self, action: #selector(FilterTableViewCell.switchValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func switchValueChanged() {
    delegate?.filterTableViewCell?(self, didChangeValue: filterSwitch.on)
  }
    
}
