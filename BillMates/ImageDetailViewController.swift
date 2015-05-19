//
//  ImageDetailViewController.swift
//  BillMates
//
//  Created by Lucas Rocali on 5/20/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    var model = Model.sharedInstance

    @IBOutlet weak var imageDetail: UIImageView!
    var billIndex:Int?
    var createBill : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //println(text!)
        
        self.imageDetail.image = model.imageToSave
        

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
