//
//  billCellTableViewCell.swift
//  BillMates
//
//  Created by Lucas Rocali on 5/25/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit

class billCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblDirection: UILabel!
    @IBOutlet weak var lblDetailes: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
