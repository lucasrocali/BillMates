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
import MediaPlayer
import MobileCoreServices

class AddBillViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, UIPopoverControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate,UINavigationControllerDelegate {
    
    var model = Model.sharedInstance
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil

    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        self.imageView.contentMode = .ScaleAspectFit
        lastChosenMediaType = info[UIImagePickerControllerMediaType] as? String
        println("1")
        if let mediaType = lastChosenMediaType {
            println("2")
            if mediaType == kUTTypeImage as NSString {
                println("3")
                image = info[UIImagePickerControllerEditedImage] as? UIImage
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func addPicture(sender: UIButton) {
        println("ui fui clicado")
        var alert:UIAlertController=UIAlertController(title: "Choose Image", message:
            nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cameraAction = UIAlertAction(title: "Camera", style:
            UIAlertActionStyle.Default)
            {
                UIAlertAction in self.pickMediaFromSource(UIImagePickerControllerSourceType.Camera)
        }
        var gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.pickMediaFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
        }
        var cancelAction = UIAlertAction(title: "Cancel", style:
            UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        // Present the actionsheet
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            //popover!.presentPopoverFromRect(saveImage.frame, inView: self.view,permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    func pickMediaFromSource(sourceType:UIImagePickerControllerSourceType) {
        let mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(sourceType)!
        if UIImagePickerController.isSourceTypeAvailable(sourceType) && mediaTypes.count > 0 {
            let picker = UIImagePickerController()
            picker.mediaTypes = mediaTypes
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            presentViewController(picker, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(
                title:"Error accessing media", message: "Unsupported media source.",
                preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var txtDescription: UITextField!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblPaidBy: UILabel!
    @IBOutlet weak var lblPerPerson: UILabel!
    
     var billCellIndex: Int = -1
    var billId : String?
    var image:UIImage?
    var lastChosenMediaType:String?
    
    @IBAction func cancelAddBill(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func doneAddBill(sender: UIBarButtonItem) {
        
        if (!model.isTotallyEmpty(txtDescription.text) && !model.isTotallyEmpty(txtValue.text)) {
            if billCellIndex < 0{
                self.model.saveBill(description: txtDescription.text, value: txtValue.text)
            } else {
                self.model.editBill(description: txtDescription.text, value: txtValue.text,billId: billId!,cellId:billCellIndex)
                
            }
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    func imageTapped(img: AnyObject)
    {
       
        if self.imageView!.image != nil {
        performSegueWithIdentifier("toImageDetail", sender: self)
        println("Cliquei na image view")
        if let mediaType = lastChosenMediaType {
            if mediaType == kUTTypeImage as NSString {
                println("Vai fuder")
                model.image = image!
                //vc.imageDetail!.image = image!
                println("fudeu")
                //vc.imageDetail!.hidden = false
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var user : PFUser = model.userObject!
        var paidByUsername : String = user["username"]! as! String
        //var imageView = self.imageView
        var tgr = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        self.imageView.addGestureRecognizer(tgr)
        self.imageView.userInteractionEnabled = true
        
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
            var perPerson : Float = valueFloat/Float(model.addedUsers.count)
            lblPerPerson.text = String(format: " %.2f per peson",perPerson)
        }
    }

    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
        updateImage()
    }
    func updateImage() {
        if let mediaType = lastChosenMediaType {
            if mediaType == kUTTypeImage as NSString {
                imageView.image = image!
                imageView.hidden = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        self.view.endEditing(true)
        
        var friendName: String = self.model.groupFriendsString[indexPath.row]
        
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
