//
//  CalculateDebtsViewController.swift
//  BillMates
//
//  Created by Lucas Rocali on 5/13/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CalculateDebtsViewController: UIViewController {
    var model = Model.sharedInstance

    @IBOutlet weak var debtsTxtView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    @IBAction func btnRefreshDebts(sender: UIButton) {
        model.calculateDebts()
        super.viewDidAppear(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        var debts = model.debtObjects
        
        //println(debts)
        var debtsStr : String = ""
        for debt in debts {
            var user1 : String = debt["user1"] as! String
            var user2 : String = debt["user2"] as! String
            var value : Float = debt["value"] as! Float
            if value < 0 {
                debtsStr = debtsStr + user1 + " --> " + user2 + " = " +  "\(value*(-1))\n"
            } else if value > 0{
                debtsStr = debtsStr + user1 + " <-- " + user2 + " = " +  "\(value)\n"
            } else {
                debtsStr = debtsStr + user1 + " -- " + user2 + " = " +  "\(value)\n"
            }
        }
        //println(debtsStr)
        debtsTxtView.text = debtsStr
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
