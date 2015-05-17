//
//  AddBillViewController.swift
//  BillMates
//
//  Created by Lucas Rocali on 4/26/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AddBillViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var model = Model.sharedInstance

    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblPaidBy: UILabel!
    
     var billCellIndex: Int = -1
    var billId : String?
    
    @IBAction func cancelAddBill(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func doneAddBill(sender: UIBarButtonItem) {
        
        if (!model.isTotallyEmpty(txtDescription.text) && !model.isTotallyEmpty(txtValue.text)) {
            if billCellIndex < 0{
                self.model.saveBill(description: txtDescription.text, value: txtValue.text)
                //elf.navigationController?.popToRootViewControllerAnimated(true)
                //var billListViewController = BillsListTableViewController()
                //model.refreshData()
            } else {
                self.model.editBill(description: txtDescription.text, value: txtValue.text,billId: billId!,cellId:billCellIndex)
                
            }
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var user : PFUser = model.userObject!
        var paidByUsername : String = user["username"]! as! String
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        tableView.delegate = self
        
        if billCellIndex < 0{
            lblPaidBy.text = "Paid by: " + paidByUsername
            println("Add")
            model.addedUsers.removeAll(keepCapacity: false)
        } else {
            println("Edit")
            let object : PFObject = self.model.billObjects[billCellIndex] as! PFObject
            txtDescription.text = object["description"] as! String
            var valueFloat : Float = object["value"] as! Float
            txtValue.text = "\(valueFloat)"
            var paidByStr = object["paidBy"] as! String
            lblPaidBy.text = "Paid by: " + paidByStr
            model.addedUsers = object["sharedWith"] as! [String]
            billId = object.objectId
        
            //txtValue.text = String(object["value"] as! Float)
        }
    }

    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        var friendName: String = self.model.groupFriendsString[indexPath.row]
        
        if model.isAddedUser(friendName){
            model.removeAddedUsers(friendName)
        } else {
            model.addAddedUsers(friendName)
        }

        tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.groupFriendsString.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! UITableViewCell
        
        var friendName: String = self.model.groupFriendsString[indexPath.row]
        cell.textLabel!.text = friendName
    
        if model.isAddedUser(friendName){
            cell.accessoryType = .Checkmark
        }
        else{
            cell.accessoryType = .None
        }
    

        return cell
    }

}
