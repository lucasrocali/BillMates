//
//  BalanceDetailViewController.swift
//  BillMates
//
//  Created by Lucas Rocali on 5/25/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit
import Parse

class BalanceDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var model = Model.sharedInstance

    @IBOutlet weak var filteredTableView: UITableView!
    var user1 : String?
    var user2 : String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if user1 != nil && user2 != nil {
            model.filterBillsByRelation(user1!,user2:user2!)
        }
        println(user1!+user2!)
        println(self.model.filteredBills.count)
        self.filteredTableView.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.filteredTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.filteredBills.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("relationalBillCell", forIndexPath: indexPath) as! UITableViewCell
        
        var object : PFObject = self.model.filteredBills.objectAtIndex(indexPath.row) as! PFObject
        cell.textLabel!.text = object["description"] as? String
        
        //cell.detailTextLabel!.text = object["value"]!.description as! String
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
   
    func DismissKeyboard(){
        view.endEditing(true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        println("segue")
        if segue.identifier == "toDetailBills"
        {
            println("segue to detailBills")
            let indexPath = self.filteredTableView.indexPathForSelectedRow()!
            
            println("Cell n: \(indexPath.row)")
            var editBill = segue.destinationViewController as! AddBillViewController
            editBill.billCellIndex = indexPath.row
            editBill.billState = 3
        }
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