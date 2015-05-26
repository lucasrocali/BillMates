//
//  CustomNavigationController.swift
//  BillMates
//
//  Created by Lucas Rocali on 5/26/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let tabBarAttributes = [NSFontAttributeName:fontTabBar]
        let tabBarAttributes = [NSFontAttributeName:fontButton]
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: fontButton]
        UIBarButtonItem.appearance().setTitleTextAttributes(tabBarAttributes, forState: UIControlState.Normal)
        UISegmentedControl.appearance().setTitleTextAttributes(tabBarAttributes, forState: UIControlState.Normal)
        //UINavigationBar.appearance().setti
        // Do any additional setup after loading the view.
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
