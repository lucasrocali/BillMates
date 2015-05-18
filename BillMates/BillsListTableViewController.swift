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
        
        model.refreshData()
        self.tableView.reloadData()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func logoutBtn(sender: UIBarButtonItem) {
        self.logout()
    }
    
    func logout() {
        println("Log out e chama view")
        PFUser.logOut()
        model.resetModel()
        
        var storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        var vc : UITabBarController = storyBoard.instantiateViewControllerWithIdentifier("initialViewController") as! UITabBarController
        
        self.presentViewController(vc, animated: false, completion: nil)

    }

    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        
        //model.calculateDebts()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        model.refreshData()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        //getData()
        self.tableView.reloadData()
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

        cell.detailTextLabel!.text = object["value"]!.description as? String

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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if segue.identifier == "listToEdit"
        {
            let indexPath = self.tableView.indexPathForSelectedRow()!
            
           println("Cell n: \(indexPath.row)")
            var editBill = segue.destinationViewController as! AddBillViewController
            editBill.billCellIndex = indexPath.row
            
        } else {
            println("ADD")
        }
    }
}
