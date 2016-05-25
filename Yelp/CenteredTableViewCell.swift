//
//  CenteredTableViewCell.swift
//  Yelp
//
//  Created by Chris Wren on 5/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

protocol CellExpansionTapDelegate: class {
  func didTapCellExpansion(centeredTableViewCell :CenteredTableViewCell)
}

class CenteredTableViewCell: UITableViewCell {
  
  var delegate :CellExpansionTapDelegate?

  @IBAction func cellTapped(sender: AnyObject) {
    delegate?.didTapCellExpansion(self)
  }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
      
        self.userInteractionEnabled = true
      self.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
