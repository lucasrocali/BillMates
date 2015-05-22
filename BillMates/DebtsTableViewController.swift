//
//  DebtsTableViewController.swift
//  BillMates
//
//  Created by Lucas Rocali on 5/16/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit

class DebtsTableViewController: UITableViewController {
    @IBOutlet weak var tableControl: UISegmentedControl!
    
    var debtsState : Int = 0 //0 for all, 1 for personal
    
    @IBAction func changeBalanceBtns(sender: UISegmentedControl) {
        switch tableControl.selectedSegmentIndex {
        case 0:
            println("ALL");
            debtsState = 0
            //self.viewDidLoad()
            self.tableView.reloadData()
        case 1:
            println("Personal");
            model.getPersonalRelations()
            debtsState = 1
            //self.viewDidLoad()
            self.tableView.reloadData()
        default:
            println("Algo errado");
        }
    }

    var model = Model.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"loadDebts", object: nil)
        

    }
    
    override func viewDidAppear(animated: Bool) {
       // model.generateDebtStrings()
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
        var n : Int?
        if debtsState == 0 {
            n = model.relations.count
        } else {
            n = model.personalRelations.count

        }
        return n!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("debtCell", forIndexPath: indexPath) as! UITableViewCell
        var relation : Relation?
        if debtsState == 0 {
        //var cellLabel : String = model.getDebtStringCell(indexPath.row)
            relation = model.relations[indexPath.row]
        } else {
              relation  = model.personalRelations[indexPath.row]
        }
        
        cell.textLabel!.text = relation!.debtStringCell
        
        cell.userInteractionEnabled = true
        if relation!.value != 0 {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else {
            cell.accessoryType = .None
        }
        
       if relation!.value == 0 {
            cell.userInteractionEnabled = false
        } else {
            cell.userInteractionEnabled = true
        }
        return cell
    }
    //-
    
    func loadList(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if segue.identifier == "relationsToFilteredBills"
        {
            println("Bora muleKOTE")
            let indexPath = self.tableView.indexPathForSelectedRow()!
            
            var filteredBills = segue.destinationViewController as! RelationalBillsTableViewController
            if debtsState == 0 {
                filteredBills.user1 = model.relations[indexPath.row].user1
                filteredBills.user2 = model.relations[indexPath.row].user2
            } else {
                filteredBills.user1 = model.personalRelations[indexPath.row].user1
                filteredBills.user2 = model.personalRelations[indexPath.row].user2
            }
        }
    }
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "relationsToFilteredBills" {
            let indexPath = self.tableView.indexPathForSelectedRow()!
            var relation : Relation?
            if debtsState == 0 {
                //var cellLabel : String = model.getDebtStringCell(indexPath.row)
                relation = model.relations[indexPath.row]
            } else {
                relation  = model.personalRelations[indexPath.row]
            }
            if relation!.value == 0 {
                return false
            }
        }
        return true
    }
}
