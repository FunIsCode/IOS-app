//
//  RiderVC.swift
//  UberAppRIder
//
//  Created by yuanqi on 2018/9/9.
//  Copyright © 2018 yuanqi. All rights reserved.
//

import UIKit
import MapKit

class RiderVC: UIViewController ,MKMapViewDelegate , CLLocationManagerDelegate, UberController{

    

    private let Rider_segue = "RiderVC"
    @IBOutlet var logout: UIBarButtonItem!
    @IBOutlet var myMap: MKMapView!
    @IBOutlet var callUberBtn: UIButton!
    
    private var locationManager = CLLocationManager()
    private var userLocation :CLLocationCoordinate2D?
    private var driverLocation :CLLocationCoordinate2D?

    
    
    private var timer = Timer()
    
    private var canCallUber = true
    private var riderCancelledRequest = false
    private var appStartedForTheFirstTime  = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeLocationManager()
        UberHandler.Instance.deleagte = self
        UberHandler.Instance.observerMessagesForRider()
    }
    
    private func initializeLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations :[CLLocation]){
        if let location = locationManager.location?.coordinate {
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta:0.01, longitudeDelta:0.01))
            myMap.setRegion(region, animated: true)
            
            // remove annotations
            let visRect = myMap.visibleMapRect
            let inRectAnnotations = myMap.annotations(in: visRect)
            for anno : MKAnnotation in myMap.annotations {
                if (inRectAnnotations.contains(anno as! AnyHashable)) {
                    myMap.removeAnnotation(anno)
                }
            }
            
            if driverLocation != nil {
                if !canCallUber {
                    let  driverAnnotation  = MKPointAnnotation()
                    driverAnnotation.coordinate = driverLocation!
                    driverAnnotation.title = "Driver Location"
                    myMap.addAnnotation(driverAnnotation)
                }
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation!
            annotation.title = "Rider Location"
            myMap.addAnnotation(annotation)
            
            
            
        }
    }  //locationManager

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        if AuthProvider.Instance.logout() {
            if !canCallUber{
                UberHandler.Instance.cancelUber()
                timer.invalidate()
            }
            dismiss(animated: true, completion: nil)
        }
        else{
             self.alerTheUser(title: "Cannot Cancel Uber", message: " Try again ")
         }
        
    }
    @objc func updateRidersLocation (){
        UberHandler.Instance.updateRidersLocation(lat: userLocation!.latitude, long: userLocation!.longitude)
    }
    
    func canCallUber(delegateCalled: Bool) {
        if delegateCalled {
            callUberBtn.setTitle("Cancel Uber", for: UIControlState.normal)
            canCallUber = false
        }else {
                callUberBtn.setTitle("Call Uber", for: UIControlState.normal)
                  canCallUber =  true
        }
        
    }
    
    
    @IBAction func CallUberAction(_ sender: UIButton) {
        if userLocation != nil {
            if canCallUber {
                 UberHandler.Instance.requestUber(latitude: Double(userLocation!.latitude), longtitude: Double(userLocation!.longitude))
                timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(RiderVC.updateRidersLocation), userInfo: nil, repeats: true)
            }else{
                riderCancelledRequest = true
                //cancel uber
                UberHandler.Instance.cancelUber()
                timer.invalidate()
                
            }
            
        }
       
        
    }
    
    func driverAcceptedRequest(requestAccepted: Bool, driverName: String) {
        if !riderCancelledRequest{
            if requestAccepted {
                alerTheUser(title: "Uber Accepted", message: "\(driverName) accepted your Uber Requested")
            }else{
                UberHandler.Instance.cancelUber();
                   timer.invalidate()
                self.alerTheUser(title: "Uber Canceled", message: " Canceled Uber Request ")
                
            }
        }
        riderCancelledRequest = false
    }
    
    func updateDriversLocation(lat: Double, long: Double) {
        driverLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    private func alerTheUser(title :String , message :String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }  //alerTheUser func
    



}
