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

class BillsListTableViewController: UITableViewController, UIAlertViewDelegate {
    
    var model = Model.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //model.getBills()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadBillList:",name:"loadBill", object: nil)
        
        //model.refreshData()
        self.tableView.reloadData()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        //Register Custom Cell
        var nib = UINib(nibName: "billCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "billCell")
        
        self.shouldPerformSegueWithIdentifier("listToEdit", sender: nil)

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    @IBAction func logoutBtn(sender: UIBarButtonItem) {
        self.logout()
    }
    
    func logout() {
        let alert = UIAlertView()
        alert.title = "Log out?"
        alert.addButtonWithTitle("Cancel")
        alert.addButtonWithTitle("Ok")
        alert.delegate = self
        alert.show()

       
        
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex)
        //println("\(buttonTitle) pressed")
        if buttonTitle == "Ok" {
           //println("Ok pressed")
            if model.isConnectedToNetwork() {
                //println("Log out e chama view")
                PFUser.logOut()
                model.resetModel()
                
                var storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                var vc : UITabBarController = storyBoard.instantiateViewControllerWithIdentifier("initialViewController") as! UITabBarController
                
                self.presentViewController(vc, animated: false, completion: nil)
            } else {
                let alert = UIAlertView()
                alert.title = "No internet connection"
                alert.message = "You cannot log out"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
            
        } else {
            //println("Cancel pressed")
        }
    }
    
    var cTimes:Int = 0
    
    func refresh(sender:AnyObject)
    {
        cTimes++
        //println(cTimes)
        // Code to refresh table view
        //println("\nREFRESH")
        //model.calculateDebts()
        model.refreshData()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        
        /*
        if model.isConnectedToNetwork() == true{
        //println("Internet Status = ON")
        model.refreshData(true)
        } else {
        //println("Internet Status = OFF")
        model.refreshData(false)
        }*/
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        //getData()
        model.sortBillList()
        self.tableView.reloadData()
    }
    
    func loadBillList(notification: NSNotification){
        //load data here
        model.sortBillList()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return model.bills.count
        return self.model.billObjects.count
    }
    //new branch
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : BillTableViewCell = tableView.dequeueReusableCellWithIdentifier("billCell") as! BillTableViewCell
        var object : PFObject = self.model.billObjects.objectAtIndex(indexPath.row) as! PFObject
        var user : String = model.userObject!["username"] as! String
        var value : Float = object["value"]! as! Float
        var paidBy : String = object["paidBy"] as! String
        var sharedWith : [String] = object["sharedWith"] as! [String]
        var nSharedWith : Int = sharedWith.count as Int
        cell.lblDescription.text = object["description"] as? String
        
        cell.lblDetailes.text =  paidBy + " paid" + " " + "$ "+(NSString(format: "%.2f",value) as! String)
        
        cell.lblValue.text = "$ "+(NSString(format: "%.2f",value/Float(nSharedWith)) as! String)
       
        //Layout
        cell.lblDescription.font = fontText
        cell.lblValue.font = fontNumbers
        cell.lblDetailes.font = fontDetails
        cell.lblDirection.font = fontDetails
        
        cell.lblDescription.textColor = cellColor0
        cell.lblValue.textColor = cellColor0
        cell.lblDetailes.textColor = cellColor0
        cell.lblDirection.textColor = cellColor0
        
        if(indexPath.row % 2 == 0) {
            cell.backgroundColor = cellColor1
        } else {
            cell.backgroundColor = cellColor2
        }
        if user == paidBy {
            cell.lblValue.textColor = textGreen
            cell.lblDirection.text = "You lent"
        } else {
            var flag = 0
            for friend in sharedWith {
                if user == friend {
                    flag = 1
                }
            }
            if flag == 1{   //User is in sharedUsers
                cell.lblValue.textColor = textOrange
                cell.lblDirection.text = "You borrowed"
            } else {
                cell.lblDirection.text = "Not included"
                cell.lblValue.textColor = textNeutral
            }
        }
        if object["activated"] as! Bool == false {
            cell.lblDescription.textColor = textNeutral
            cell.lblValue.textColor = textNeutral
            cell.lblDirection.textColor = textNeutral
            cell.lblDetailes.textColor = textNeutral
            
            cell.lblDirection.text = "Bill was settled up"
            cell.lblValue.text = "$ 0.00"
        }
        
        
        /*
        cell.textLabel!.text = object["description"] as? String
        
        cell.detailTextLabel!.text = object["value"]!.description as? String
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        */
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //let appDelegate =
        //UIApplication.sharedApplication().delegate as! AppDelegate
        
        //let managedContext = appDelegate.managedObjectContext!
        
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            
            if model.deleteBill(indexPath.row) {
                println("DELETOU A \(indexPath.row) PORRA")
            } else {
                println("ERRO PRA DELETAR")
            }
            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if segue.identifier == "listToEdit"
        {
            
            let indexPath : NSIndexPath = sender as! NSIndexPath
            //println("bora editar indexpahtrow: \(indexPath.row)")
            //println("Cell n: \(indexPath.row)")
            var editBill = segue.destinationViewController as! AddBillViewController
            editBill.billCellIndex = indexPath.row
            editBill.billState = 1
            
        } else {
            var editBill = segue.destinationViewController as! AddBillViewController
            editBill.billState = 0
            
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("listToEdit", sender: indexPath)
    }
}
