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
    
    @IBAction func cancelAddBill(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func doneAddBill(sender: UIBarButtonItem) {
        
        self.model.saveBill(description: txtDescription.text, value: txtValue.text)
        
                
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        //println("Done Pressed")
        
        //if (!model.isTotallyEmpty(txtDescription.text) && !model.isTotallyEmpty(txtValue.text)) {
          //  model.saveBill(description: txtDescription.text, value: txtValue.text)
        
            //self.navigationController?.popToRootViewControllerAnimated(true)
            //self.view.endEditing(true)
        //}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //model.getUsers()
        //println(model.users[0].attName)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        tableView.delegate = self
        //println(model.users[1].attName)
    }

    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println("You selected cell \(indexPath.row)")
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        var object : PFObject = self.model.friendObjects.objectAtIndex(indexPath.row) as! PFObject
        let friendName = object["friendName"] as? String
        
        
        
        if model.isAddedUser(friendName!){
            model.removeAddedUsers(friendName!)
        } else {
            model.addAddedUsers(friendName!)
        }
        
        
        /*
        var houseMate:HouseMate = self.model.houseMates[indexPath.row] as HouseMate
        
        houseMate.added = !houseMate.added

        self.model.houseMates[indexPath.row] = houseMate*/
        tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //println("count")
        return model.friendObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! UITableViewCell
        
        var object : PFObject = self.model.friendObjects.objectAtIndex(indexPath.row) as! PFObject
        let friendName = object["friendName"] as? String
        cell.textLabel!.text = friendName
    
        
        //println("addedUser")
        if model.isAddedUser(friendName!){
            //println("checked")
            cell.accessoryType = .Checkmark
        }
        else{
            //println("None\n")
            cell.accessoryType = .None
        }
    

        return cell
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
