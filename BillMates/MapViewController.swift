//
//  MapViewController.swift
//  BillMates
//
//  Created by Lucas Rocali on 6/8/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var model = Model.sharedInstance
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var locValue : CLLocationCoordinate2D?
    
    func saveLocation(sender: UIBarButtonItem) {
        if locValue != nil {
            model.setLocation(locValue!)
        }
        print("pop")
        self.navigationController?.popViewControllerAnimated(true)
        //self.navigationController?.popToViewController(AddBillViewController(), animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        print("Request user")
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("Location enabled")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        let rightButton = UIBarButtonItem(title: "Save Location", style: UIBarButtonItemStyle.Plain, target: self, action: "saveLocation:")
        navigationItem.rightBarButtonItem = rightButton
        
        //let initialLocation = CLLocation(latitude: -37.8140000	, longitude: 144.9633200)
        
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        locValue = manager.location!.coordinate
        if locValue != nil {
            let newlLocation = CLLocation(latitude: locValue!.latitude	, longitude: locValue!.longitude)
            print("locations = \(locValue!.latitude) \(locValue!.longitude)")
            /*//var pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(your latitude, your longitude)
            var objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = locValue
            objectAnnotation.title = "Your Location"
            self.mapView.addAnnotation(objectAnnotation)*/
            self.mapView.showsUserLocation = true
            centerMapOnLocation(newlLocation)
        }
        
    }
    
    let regionRadius: CLLocationDistance = 100
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
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
