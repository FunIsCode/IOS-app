//
//  UberHandler.swift
//  Uber App
//
//  Created by yuanqi on 2018/9/10.
//  Copyright © 2018 yuanqi. All rights reserved.
//

import Foundation
import Firebase

protocol UberController : class {
    func accpetUber(lat: Double , log: Double )
    func riderCanceledUber()
    func uberCanceled()
    func updateRridersLocation(lat:Double ,long:Double)
}


class UberHandler{
    private static let _instance = UberHandler()
    weak var delegate : UberController?
    
    var rider = ""
    var driver = ""
    var driver_id = ""
    
    
    static var Instance : UberHandler {
        return _instance
    }
    
    func obeserveMessagesForDriver(){
        // rider requested an uber  // uber requested dababase
        DBProvider.Instance.requestRef.observe(DataEventType.childAdded , with: { (snapshot) in
            if let data = snapshot.value as? Dictionary<String, Any> {
                if let latitude = data[Constants.LATITUDE] as? Double {
                    if let longitude = data[Constants.LONGITUDE] as? Double{
                       //inform driver vc
                        self.delegate?.accpetUber(lat: latitude, log: longitude) // calling the protocol function
                    }
                }
                if let name = data[Constants.NAME] as? String {
                    self.rider = name // which means the the driver is taking this rider which from firebase
                }
            }
        });
            
            //rider cancelled uber    // uber request database
            DBProvider.Instance.requestRef.observe(.childRemoved, with: {(snapshot) in
                if let data  = snapshot.value as? Dictionary<String ,Any> {
                    if let name  = data[Constants.NAME] as? String {
                        if name == self.rider {
                            self.rider = ""
                            self.delegate?.riderCanceledUber()
                        }
                    }
                }
            });
        
        
        // RIder update location   // uber request database
        DBProvider.Instance.requestRef.observe(.childChanged, with: {(snapshot) in
            if let data  = snapshot.value as? Dictionary<String ,Any> {
                if let lat  = data[Constants.LATITUDE] as? Double {
                    if let long =  data[Constants.LONGITUDE] as? Double {
                        self.delegate?.updateRridersLocation(lat: lat, long: long)
                    }
                }
            }
        });
        
        //driver accpets uber       // uber accepted database
        DBProvider.Instance.requestAcceptedRef.observe(.childAdded, with: {(snapshot) in
            if let data  = snapshot.value as? Dictionary<String ,Any>{
                if let name  = data[Constants.NAME] as? String {
                    if name == self.driver {
                        self.driver_id = snapshot.key
                        
                    }
                }
            }
        })
        
        //driver cancels uber       // uber accepted database
        DBProvider.Instance.requestAcceptedRef.observe(.childRemoved, with: {(snapshot) in
            if let data  = snapshot.value as? Dictionary<String ,Any>{
                if let name  = data[Constants.NAME] as? String {
                    if name == self.driver {
                        self.delegate?.uberCanceled()

                    }
                }
            }
        })
        
    //
    }// ob func
    
    
    
    func uberAccepted(lat:Double , long :Double  ){
        let data: [ String: Any] = [ Constants.NAME : driver , Constants.LATITUDE : lat , Constants.LONGITUDE : long ]
        DBProvider.Instance.requestAcceptedRef.childByAutoId().setValue(data)
        // uber accepted database
    }
    
    func cancelUberForDriver(){
        DBProvider.Instance.requestAcceptedRef.child(driver_id).removeValue()
        // uber accepted database
        
    }
    
    func updateDriverLocation(lat:Double , long:Double
        )
    { DBProvider.Instance.requestAcceptedRef.child(driver_id).updateChildValues([Constants.LATITUDE: lat, Constants.LONGITUDE:long])
             // uber accepted database
        
    }
   
    
}// class
