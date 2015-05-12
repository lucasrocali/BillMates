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
        
        if (!model.isTotallyEmpty(txtDescription.text) && !model.isTotallyEmpty(txtValue.text)) {
            self.model.saveBill(description: txtDescription.text, value: txtValue.text)
            self.navigationController?.popToRootViewControllerAnimated(true)
            var billListViewController = BillsListTableViewController()
            billListViewController.getData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        tableView.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        var friendName: String = self.model.friendString[indexPath.row]
        
        if model.isAddedUser(friendName){
            model.removeAddedUsers(friendName)
        } else {
            model.addAddedUsers(friendName)
        }

        tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.friendString.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! UITableViewCell
        
        var friendName: String = self.model.friendString[indexPath.row]
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
