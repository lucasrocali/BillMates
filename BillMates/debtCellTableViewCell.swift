//
//  debtCellTableViewCell.swift
//  BillMates
//
//  Created by Lucas Rocali on 5/24/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit

class debtCellTableViewCell: UITableViewCell {

    @IBOutlet weak var lblUser1: UILabel!
    @IBOutlet weak var lblUser2: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var btnSettledUp: UIButton!
    @IBOutlet weak var imgDirection: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        btnSettledUp.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0.2, alpha: 1)
        //backgroundColor = UIColor(red: 0, green: 0, blue: 0.2, alpha: 0.1)
        //backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        // Configure the view for the selected state
    }

}
