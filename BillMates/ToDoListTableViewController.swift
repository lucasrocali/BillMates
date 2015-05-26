//
//  ToDoListTableViewController.swift
//  BillMates
//
//  Created by Lucas Rocali on 5/25/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit
import Parse

class ToDoListTableViewController: UITableViewController, UIAlertViewDelegate {

    var model = Model.sharedInstance
    @IBOutlet weak var addToDoItem: UIBarButtonItem!
    @IBAction func addToDoItem(sender: AnyObject) {
        var alert = UIAlertView()
        alert.title = "Enter ToDo"
        alert.addButtonWithTitle("Add")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.addButtonWithTitle("Cancel")
        alert.delegate = self
        alert.show()
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex)
        ////println("\(buttonTitle) pressed")
        if buttonTitle == "Add" {
            let textField = alertView.textFieldAtIndex(0)
            print(textField!.text)
            model.createToDoItem(textField!.text)
            
        } else {
            //println("Cancel pressed")
        }
    }

    func loadToDoList(notification: NSNotification){
        //load data here
        //println("Load To Do List")
        self.tableView.reloadData()
    }
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        //println("\nREFRESH")
        //model.calculateDebts()
        //model.refreshData()
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
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.reloadData()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadToDoList:",name:"loadToDo", object: nil)
        
        
        //Register Custom Cell
        var nib = UINib(nibName: "toDoCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "toDoCell")
        
        //self.shouldPerformSegueWithIdentifier("listToEdit", sender: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
  

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //let appDelegate =
       // UIApplication.sharedApplication().delegate as! AppDelegate
        
        //let managedContext = appDelegate.managedObjectContext!
        
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            
            //println("delete To Do ")
            //model.deleteBill(indexPath.row)
            model.deleteToDoItem(indexPath.row)
            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        self.view.endEditing(true)
        //println("clicked at ]\(indexPath.row)")
        
        var toDoItem : PFObject = model.toDoList.objectAtIndex(indexPath.row) as! PFObject
        var state : Bool = toDoItem["done"] as! Bool
        toDoItem["done"] = !state
        toDoItem["whoDone"] = model.userObject!["username"] as! String
        toDoItem.saveEventually()
        model.sortToDoItems()
        
        /*var friendName: String = self.model.groupFriendsString[indexPath.row]
        
        if model.isAddedUser(friendName){
            model.removeAddedUsers(friendName)
        } else {
            model.addAddedUsers(friendName)
        }
        if (!model.isTotallyEmpty(txtValue.text)) && model.addedUsers.count > 0{
            var value : Float =  NSString(string: txtValue.text).floatValue
            var perPerson : Float = value/Float(model.addedUsers.count)
            lblPerPerson.text = String(format: " %.2f per peson",perPerson)
        } else {
            lblPerPerson.text = "0.00 per peson"
        }*/
        tableView.reloadData()
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //println("COUNT: \(model.toDoList.count)")
        return model.toDoList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ToDoTableViewCell = tableView.dequeueReusableCellWithIdentifier("toDoCell", forIndexPath: indexPath) as! ToDoTableViewCell

        var toDoItem : PFObject = model.toDoList.objectAtIndex(indexPath.row) as! PFObject
        
        cell.lblItem.text = toDoItem["description"] as! String
        cell.lblWhoCreated.text = "Created by: " + (toDoItem["whoCreated"] as! String)
        cell.lblWhoDid.text = "Executed by: " + (toDoItem["whoDone"] as! String)
        
        //Layout
        cell.lblItem.font = fontText
        cell.lblWhoCreated.font = fontDetails
        cell.lblWhoDid.font = fontDetails
        
        if toDoItem["done"] as! Bool {
            cell.imgCheck.image = imgChecked
            cell.lblWhoDid.hidden = false
        } else {
             cell.imgCheck.image = imgUnchecked
            cell.lblWhoDid.hidden = true
        }
        if(indexPath.row % 2 == 0) {
            cell.backgroundColor = cellColor1
        } else {
            cell.backgroundColor = cellColor2
        }

        return cell
    }
}
