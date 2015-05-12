//
//  CalculateDebtsViewController.swift
//  BillMates
//
//  Created by Lucas Rocali on 5/13/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit

class CalculateDebtsViewController: UIViewController {
    var model = Model.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnCalculateDebts(sender: UIButton) {
            model.calculateDebts()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
