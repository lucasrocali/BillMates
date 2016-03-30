//
//  RelationalBillsTableViewController.swift
//  BillMates
//
//  Created by Lucas Rocali on 5/18/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit
import Parse
import ParseUI

//Comments na RelationBills
class RelationalBillsTableViewController: UITableViewController {

    var model = Model.sharedInstance
    var user1 : String?
    var user2 : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user1 != nil && user2 != nil {
            model.filterBillsByRelation(user1!,user2:user2!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.filteredBills.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("relationalBillCell", forIndexPath: indexPath) as! UITableViewCell

        var object : PFObject = self.model.filteredBills.objectAtIndex(indexPath.row) as! PFObject
        cell.textLabel!.text = object["description"] as? String
        
        cell.detailTextLabel!.text = object["value"]!.description as? String
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if segue.identifier == "toDetailBills"
        {
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            print("Cell n: \(indexPath.row)")
            var editBill = segue.destinationViewController as! AddBillViewController
            editBill.billCellIndex = indexPath.row
            editBill.billState = 3
        }
    }
}
