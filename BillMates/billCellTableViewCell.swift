//
//  BillCellTableViewCell.swift
//  BillMates
//
//  Created by Mateus Cirolini on 25/05/2015.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit

class BillCellTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDescription: UILabel!

    @IBOutlet weak var lblDetailes: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var lblDirection: UILabel!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
/*
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
    
}*/
