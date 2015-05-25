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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadDebtList:",name:"loadDebts", object: nil)
        
        //Register Custom Cell
        var nib = UINib(nibName: "debtCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "debtCell")
        
        self.shouldPerformSegueWithIdentifier("balanceToBalanceDetail", sender: nil)

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
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
        let cell : debtCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("debtCell") as! debtCellTableViewCell
        
        // Populating Cell
        
        var relation : Relation?
        if debtsState == 0 {
        //var cellLabel : String = model.getDebtStringCell(indexPath.row)
            relation = model.relations[indexPath.row]
        } else {
              relation  = model.personalRelations[indexPath.row]
        }
       
        
        cell.lblUser1.text = relation!.user1
        cell.lblUser2.text = relation!.user2
        cell.lblValue.text = "$ "+(NSString(format: "%.2f",abs(relation!.value)) as String)
        cell.lblDirection.hidden = false
        cell.lblLeftUser.hidden = false
        cell.lblRightUser.hidden = false
        
        //cell.btnSettledUp.layer.cornerRadius = 4
        //cell.btnSettledUp.addTarget(self, action: "settleUp:", forControlEvents: .TouchUpInside)
        //cell.btnSettledUp.tag = indexPath.row
        
        //Standart Cell Layout
        
        //tableView.separatorColor = UIColor.clearColor()
        cell.lblValue.textColor = cellColor0
        cell.lblUser1.textColor = cellColor0
        cell.lblUser2.textColor = cellColor0
        
        cell.lblValue.font = fontNumbers
        cell.lblDirection.font = fontDetails
        cell.lblLeftUser.font = fontDetails
        cell.lblRightUser.font = fontDetails
        cell.lblUser1.font = fontText
        cell.lblUser2.font = fontText
        
        
        if(indexPath.row % 2 == 0) {
            cell.backgroundColor = cellColor1
        } else {
            cell.backgroundColor = cellColor2
        }
        
        if relation!.value == 0 {
            cell.lblDirection.hidden = true
            cell.lblLeftUser.hidden = true
            cell.lblRightUser.hidden = true
            cell.userInteractionEnabled = false
            cell.imgDirection.hidden = (true)
            //cell.btnSettledUp.hidden = (true)
            cell.lblValue.textColor = textNeutral
            cell.lblUser1.textColor = textNeutral
            cell.lblUser2.textColor = textNeutral
            //cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
            //cell.imgDirection.image = UIImage(named: "AddUser.png")
        } else if relation!.value > 0 {
            cell.userInteractionEnabled = true
            cell.imgDirection.hidden = (false)
            cell.lblLeftUser.text = relation!.user2
            //cell.lblLeftUser.textColor = textGreen
            cell.lblDirection.text = " owes to"
            cell.lblRightUser.text = " " + relation!.user1
            cell.lblValue.textColor = textGreen
            //cell.lblRightUser.textColor = textOrange
            cell.imgDirection.image = UIImage(named: "arrow2to1.png")
        } else {
            cell.userInteractionEnabled = true
            cell.imgDirection.hidden = (false)
            cell.lblLeftUser.text = relation!.user1
            //cell.lblLeftUser.textColor = textOrange
            cell.lblDirection.text = " owes to"
            cell.lblRightUser.text = " " + relation!.user2
            cell.lblValue.textColor = textOrange
            //cell.btnSettledUp.hidden = (false)
            cell.imgDirection.image = UIImage(named: "arrow1to2.png")
        }
        
        /*
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
        }*/
        return cell
    }
    //-
    /*
    func settleUp(sender: UIButton!) {
        var relation : Relation?
        if debtsState == 0 {
            //var cellLabel : String = model.getDebtStringCell(indexPath.row)
            relation = model.relations[sender.tag]
        } else {
            relation  = model.personalRelations[sender.tag]
        }
        println("Settle Up for \(relation!.user1) and \(relation!.user2)")
    }
    */
    func loadDebtList(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
         println("segue")
        if segue.identifier == "balanceToBalanceDetail" && sender != nil
        {
            println("Bora muleKOTE")
            let indexPath : NSIndexPath = sender as! NSIndexPath
            
            var filteredBills = segue.destinationViewController as! BalanceDetailViewController
            if debtsState == 0 {
                filteredBills.user1 = model.relations[indexPath.row].user1
                filteredBills.user2 = model.relations[indexPath.row].user2
                filteredBills.value = model.relations[indexPath.row].value
            } else {
                filteredBills.user1 = model.personalRelations[indexPath.row].user1
                filteredBills.user2 = model.personalRelations[indexPath.row].user2
                filteredBills.value = model.personalRelations[indexPath.row].value
            }
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("balanceToBalanceDetail", sender: indexPath)
    }
    /*
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
       
        if sender != nil {
            println("nil")
            return false
        }
        if identifier == "relationsToFilteredBills" && sender != nil{
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
    }*/
}
