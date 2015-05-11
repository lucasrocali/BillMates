//
//  BillDetailViewController.swift
//  BillMates
//
//  Created by Lucas Rocali on 4/26/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class BillDetailViewController: UIViewController {

    var model = Model.sharedInstance
    
    var billCellIndex: Int?
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblBillOwner: UILabel!
    @IBOutlet weak var lblBillUsers: UILabel!
    override func viewDidLoad() {
        println(billCellIndex!)
        
        var object = model.getBill(billCellIndex!)
        
        //println(dbValue.description)
        self.lblDescription.text = object["description"] as! String
        var dbValue = object["value"] as! Double
        self.lblValue.text = dbValue.description
        self.lblBillOwner.text = object["paidBy"] as! String
        var friends : Array<String>
        friends = object["sharedWith"] as! Array<String>
        var friendsStr : String = ""
        for friend in friends {
            friendsStr = friendsStr + friend + ", "
        }
        self.lblBillUsers.text = friendsStr
    
        /*//model.getBills()
        //model.getUsers()
        super.viewDidLoad()
        //println(billCellIndex!)
        var object = model.getBill(billCellIndex!) as! PFObject
        self.lblDescription.text = object["description"] as? String
        self.lblValue.text = object["value"] as? String
        
        
        //println(bill.getBillOwner().attName)
        
        /*lblDescription.text = bill.getDescrition()
        lblValue.text = bill.getValue()
        //lblBillOwner.text = bill.getBillOwner().attName
        var users = bill.getBillUsers()
        var usersNames:String = ""
        for user in users {
            usersNames = usersNames + user.attName + " - "
        }
        lblBillUsers.text = usersNames
        /*for user in ([User])users {
            println(user.attName)
        }*/*/*/
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
