//
//  LabelImageTableViewCell.swift
//  Yelp
//
//  Created by Chris Wren on 5/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class LabelImageTableViewCell: UITableViewCell {

  @IBOutlet weak var imageTableCellImage: UIImageView!
  @IBOutlet weak var imageTableCellLabel: UILabel!
  
  weak var delegate :CellExpansionTapDelegate?
  
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
  
  func cellTapped() {
    delegate?.didTapCellExpansion(self)
  }
    
}
