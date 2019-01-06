//
//  DriverVC.swift
//  Uber App
//
//  Created by yuanqi on 2018/9/9.
//  Copyright © 2018 yuanqi. All rights reserved.
//

import UIKit
import MapKit
class DriverVC: UIViewController,MKMapViewDelegate , CLLocationManagerDelegate ,UberController{
  
    @IBOutlet var acceptUberBtn: UIButton!
    @IBOutlet var myMap: MKMapView!
    private var locationManager = CLLocationManager()
    private var userLocation :CLLocationCoordinate2D?
    private var riderLocation :CLLocationCoordinate2D?
    
    private var timer = Timer()
    private var acceptedUber = false
    private var driverCancelledUber = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeLocationManager()
        UberHandler.Instance.delegate = self

        // listening to certain events
        UberHandler.Instance.obeserveMessagesForDriver()
    }
    
    
     //  get the location function
    private func initializeLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    // locationManager function
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
            
            //after driver gets the order
            if riderLocation != nil {
                if acceptedUber {
                    let riderAnnotation = MKPointAnnotation()
                    riderAnnotation.coordinate = riderLocation!
                    riderAnnotation.title = "Riders Location"
                    myMap.addAnnotation(riderAnnotation)
                }
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation!
            annotation.title = "Driver Location"
            myMap.addAnnotation(annotation)
        }
    }  //locationManager
    
    //redundant function
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //action cancelUber
    @IBAction func cancelUberAction(_ sender: UIButton) {
        if acceptedUber {
            driverCancelledUber = true
            self.acceptUberBtn.isHidden = true
            UberHandler.Instance.cancelUberForDriver()
            //invalidate timer
            timer.invalidate()
        }
    }
 
    
    //action log out
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        if AuthProvider.Instance.logout() {
            if acceptedUber {
                acceptUberBtn.isHidden = true
                UberHandler.Instance.cancelUberForDriver()
                timer.invalidate()
            }
            dismiss(animated: true, completion: nil)
        }
        else{
            uberRequest(title: "Could not Log out", message: "We could not logout at the moment, please try again later", requestAlive: false)
//            alerTheUser(title: "Could not Log out", message: "We could not logout at the moment, please try again later")
        }
    }
    
    
    //protocol function
    func accpetUber(lat: Double, log: Double) {
        if !acceptedUber{
            uberRequest(title: "Uber Request ", message: "You have a request for an uber at this location lat: \(lat) , long :\(log)", requestAlive: true)
        }
    }
    
    //protocol function
    func updateRridersLocation(lat:Double ,long:Double){
        riderLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
    }
    
    
   //protocol function
    func riderCanceledUber(){
        if !driverCancelledUber {
            //cancel the uber from riderrs peespetive
            UberHandler.Instance.cancelUberForDriver()
            self.acceptedUber = false
            self.acceptUberBtn.isHidden = true
            uberRequest(title: "Uber Canceled", message: "The rider has canceled the Uber", requestAlive: false)
        }
    }//
    
    
    
  //protocol function
    func uberCanceled(){
        acceptedUber =  false
        acceptUberBtn.isHidden = true
        //invalidates timer
        timer.invalidate()
    }//
    
  
    
    
    @objc func updateDriversLocation(){
        UberHandler.Instance.updateDriverLocation(lat: userLocation!.latitude, long: userLocation!.longitude)
    }
    
    
    
    
    private func uberRequest(title:String , message :String , requestAlive: Bool){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if requestAlive {
            let accept = UIAlertAction(title: "Accept", style: .default, handler: {(alertAction : UIAlertAction) in
                self.acceptedUber = true
                self.acceptUberBtn.isHidden = false
                self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(DriverVC.updateDriversLocation), userInfo: nil, repeats: true)
                UberHandler.Instance.uberAccepted(lat: Double(self.userLocation!.latitude), long: Double(self.userLocation!.longitude))
                // inform we accept the uber
            })
    
            let cancel = UIAlertAction(title: "Cancel" , style: .default, handler: nil)
            alert.addAction(accept)
            alert.addAction(cancel)
        }
        else{
            let ok  = UIAlertAction(title: "OK" , style: .default, handler: nil)
            alert.addAction(ok)
        }
        present(alert, animated:  true , completion : nil)
        
    }
    
    private func alerTheUser(title :String , message :String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }  //alerTheUser func
    
    
    
  
}
