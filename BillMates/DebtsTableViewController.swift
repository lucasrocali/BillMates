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
        self.tableView.reloadData()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        model.generateDebtStrings()
        self.tableView.reloadData()
    }

    func refresh(sender:AnyObject)
    {
        if model.connectionStatus! {
        model.calculateDebts(false)
        } else {
            let alert = UIAlertView()
            alert.title = "No internet connection"
            alert.message = "Debts cannot be calculated whithout information from other users"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.relations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("debtCell", forIndexPath: indexPath) as! UITableViewCell

        //var cellLabel : String = model.getDebtStringCell(indexPath.row)
        var relation : Relation = model.relations[indexPath.row]
        
        cell.textLabel!.text = relation.debtStringCell
        
        cell.userInteractionEnabled = true
        if relation.value != 0 {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else {
            cell.userInteractionEnabled = false
        }
        return cell
    }
    //-
    
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
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "relationsToFilteredBills" {
            let indexPath = self.tableView.indexPathForSelectedRow()!
            var relation : Relation = model.relations[indexPath.row]
            if relation.value == 0 {
                return false
            }
        }
        return true
    }
}
