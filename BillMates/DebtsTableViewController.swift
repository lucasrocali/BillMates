//
//  DebtsTableViewController.swift
//  BillMates
//
//  Created by Lucas Rocali on 5/16/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit

class DebtsTableViewController: UITableViewController {

    var model = Model.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        //model.calculateDebts(true)
        self.tableView.reloadData()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        model.generateDebtStrings()
        self.tableView.reloadData()
    }

    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        
        //model.calculateDebts()
        model.calculateDebts(false)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        //model.refreshData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return model.relations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("debtCell", forIndexPath: indexPath) as! UITableViewCell

        var cellLabel : String = model.getDebtStringCell(indexPath.row)
        
        cell.textLabel!.text = cellLabel
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if segue.identifier == "relationsToFilteredBills"
        {
            println("Bora muleKOTE")
            let indexPath = self.tableView.indexPathForSelectedRow()!
            
            var filteredBills = segue.destinationViewController as! RelationalBillsTableViewController
            filteredBills.user1 = model.relations[indexPath.row].user1
            filteredBills.user2 = model.relations[indexPath.row].user2
        }
    }
}
