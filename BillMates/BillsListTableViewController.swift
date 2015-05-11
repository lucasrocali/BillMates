//
//  BillsListTableViewController.swift
//  BillMates
//
//  Created by Lucas Rocali on 4/26/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class BillsListTableViewController: UITableViewController {

    var model = Model.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //model.getBills()
        getData()
        self.tableView.reloadData()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        getData()
        self.tableView.reloadData()
    }
    
    func getData() {
        if (PFUser.currentUser() != nil){
            model.fetchAllObjects()
            //model.fetchAllObjectsFromLocalDataStore()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return model.bills.count
        return self.model.billObjects.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("billCell", forIndexPath: indexPath) as! UITableViewCell

        var object : PFObject = self.model.billObjects.objectAtIndex(indexPath.row) as! PFObject
        cell.textLabel!.text = object["description"] as? String
        //var valueTxt = String(format: "%.2f", object["value"]!)
        cell.detailTextLabel!.text = object["value"]!.description as? String
        /*
        let bill = model.getBill(indexPath.row)
        cell.textLabel!.text = bill.attDescription
        cell.detailTextLabel!.text = bill.attValue
        */
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            
            model.deleteBill(indexPath.row)
            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("BillsListToBillDetail", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        
        if segue.identifier == "BillsListToBillDetail"
        {
            //println("Segue!")
            let indexPath = self.tableView.indexPathForSelectedRow()!
            let object : PFObject = self.model.billObjects[indexPath.row] as! PFObject
            var billDetail = segue.destinationViewController as! UIViewController
            billDetail.title = object["description"] as? String

           println("Cell n: \(indexPath.row)")
            var chosenBill = segue.destinationViewController as! BillDetailViewController
            chosenBill.billCellIndex = indexPath.row
            
        }
    }
    

}
