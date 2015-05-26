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

    @IBOutlet weak var imgDirection: UIImageView!
    @IBOutlet weak var lblDirection: UILabel!
    @IBOutlet weak var lblUser1: UILabel!
    @IBOutlet weak var lblUser2: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSettleUp: UIButton!
    @IBAction func btnSettleUp(sender: UIButton) {
        btnSettleUp.backgroundColor = cellColor4
        model.settleUp(user1!, user2: user2!)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBAction func btnSettledDown(sender: UIButton) {
        btnSettleUp.backgroundColor = cellColor3
    }
    
    @IBOutlet weak var filteredTableView: UITableView!
    var currentUser : String?
    var user1 : String?
    var user2 : String?
    var value : Float?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if user1 != nil && user2 != nil {
            model.filterBillsByRelation(user1!,user2:user2!)
        }
        //println(user1!+user2!)
        //println(self.model.filteredBills.count)
        self.filteredTableView.reloadData()
        
        // Populating
        
        currentUser = model.userObject!["username"] as? String
       // //println(currentUser)
       // //println(user1!)
        
        if value > 0 {
            lblUser1.text = user1
            lblUser2.text = user2
            lblValue.text = "$ "+(NSString(format: "%.2f",abs(value!)) as String)
            lblDirection.text = user2! + " owns to" + " " + user1!
            lblValue.textColor = textGreen
            imgDirection.image = UIImage(named: "arrow2to1.png")
        } else {
            lblUser1.text = user1
            lblUser2.text = user2
            lblValue.text = "$ "+(NSString(format: "%.2f",abs(value!)) as String)
            lblDirection.text = user2! + " owns to" + " " + user1!
            lblValue.textColor = textOrange
            imgDirection.image = UIImage(named: "arrow1to2.png")
        }

        lblTitle.text = "Related bills"
        
        //Layout
        
        lblUser1.font = fontText
        lblUser2.font = fontText
        lblDirection.font = fontDetails
        lblValue.font = fontNumbers
        lblTitle.font = fontNeutral
        
        btnSettleUp.titleLabel!.text = "Settle up"
        btnSettleUp.titleLabel!.font = fontButton
        btnSettleUp.backgroundColor = cellColor4
        btnSettleUp.titleLabel!.textColor = colorWhite
        btnSettleUp.titleLabel!.highlightedTextColor = cellColor3
        
        lblTitle.backgroundColor = colorLightOrange
        
        var nib = UINib(nibName: "billCell", bundle: nil)
        filteredTableView.registerNib(nib, forCellReuseIdentifier: "billCell")
        
        self.shouldPerformSegueWithIdentifier("toDetailBills", sender: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func viewDidAppear(animated: Bool) {
        self.filteredTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.filteredBills.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : BillTableViewCell = tableView.dequeueReusableCellWithIdentifier("billCell") as! BillTableViewCell
        var object : PFObject = self.model.filteredBills.objectAtIndex(indexPath.row) as! PFObject
        var user : String = model.userObject!["username"] as! String
        var value : Float = object["value"]! as! Float
        var paidBy : String = object["paidBy"] as! String
        var sharedWith : [String] = object["sharedWith"] as! [String]
        var nSharedWith : Int = sharedWith.count as Int
        //println(object)
        
        cell.lblDescription.text = object["description"] as! String
        
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
            cell.lblDirection.text = user1! + " lent"
        } else {
            var flag = 0
            for friend in sharedWith {
                if user == friend {
                    flag = 1
                }
            }
            if flag == 1{   //User is in sharedUsers
                cell.lblValue.textColor = textOrange
                cell.lblDirection.text = user1! + " borrowed"
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
        let cell = tableView.dequeueReusableCellWithIdentifier("relationalBillCell", forIndexPath: indexPath) as! UITableViewCell
        
        var object : PFObject = self.model.filteredBills.objectAtIndex(indexPath.row) as! PFObject
        cell.textLabel!.text = object["description"] as? String
        
        
        //cell.detailTextLabel!.text = object["value"]!.description as! String
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator*/
        return cell
    }
   
    func DismissKeyboard(){
        view.endEditing(true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        //println("segue")
        if segue.identifier == "toDetailBills"
        {
            //println("segue to detailBills")
            let indexPath : NSIndexPath = sender as! NSIndexPath
            
            //println("Cell n: \(indexPath.row)")
            var editBill = segue.destinationViewController as! AddBillViewController
            editBill.billCellIndex = indexPath.row
            editBill.billState = 3
        }
    }

   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("toDetailBills", sender: indexPath)
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
