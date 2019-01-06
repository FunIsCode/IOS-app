//
//  UberHandler.swift
//  UberAppRIder
//
//  Created by yuanqi on 2018/9/10.
//  Copyright © 2018 yuanqi. All rights reserved.
//

import Foundation
import Firebase
protocol UberController : class {
    func canCallUber(delegateCalled : Bool)
    func driverAcceptedRequest(requestAccepted : Bool , driverName : String)
    func updateDriversLocation(lat:Double ,long:Double)
}

class UberHandler {
    private static let _instance = UberHandler()
    weak var deleagte:UberController?
    var rider = ""
    var driver = ""
    var rider_id = "" 
    
    
    static var Instance : UberHandler {
        return _instance
    }
    
    func observerMessagesForRider(){
        //rider request an uber
        DBProvider.Instance.requestRef.observe(DataEventType.childAdded,with :{(snapshot)  in
            print(snapshot.value  as Any)
            if let data = snapshot.value as? Dictionary<String , Any> {
                if let name = data[Constants.NAME] as? String {
                    if  name == self.rider {
                        self.rider_id = snapshot.key
                        self.deleagte?.canCallUber(delegateCalled: true)
                        print("the value is \(self.rider_id)")
                    }
                }
            }
        })
        
        //rider cancel uber
        DBProvider.Instance.requestRef.observe(DataEventType.childRemoved,with :{(snapshot)  in
            print(snapshot.value  as Any)
            if let data = snapshot.value as? Dictionary<String , Any> {
                if let name = data[Constants.NAME] as? String {
                    if  name == self.rider {
                        self.rider_id = snapshot.key
                        self.deleagte?.canCallUber(delegateCalled: false)
                        print("the value is \(self.rider_id)")
                    }
                }
            }
        })
        //driver accept uber
        DBProvider.Instance.reuqestAcceptedRef.observe(.childAdded, with: {(snapshot) in
            if let data = snapshot.value as? Dictionary<String, Any>{
                if let name = data[Constants.NAME] as? String {
                    if self.driver == ""{
                        self.driver = name
                        self.deleagte?.driverAcceptedRequest(requestAccepted: true, driverName: self.driver)
                    }
                }
                
            }
        })
        
        // driver canceled uber
        DBProvider.Instance.reuqestAcceptedRef.observe(.childRemoved, with: {(snapshot) in
            if let data = snapshot.value as? Dictionary<String, Any>{
                if let name = data[Constants.NAME] as? String {
                    if name == self.driver{
                        self.driver = ""
                        self.deleagte?.driverAcceptedRequest(requestAccepted: false, driverName: name)
                    }
                }
                
            }
        })
        
        //driver updating location
        DBProvider.Instance.reuqestAcceptedRef.observe(.childChanged, with: {(snapshot) in
            if let data = snapshot.value as? Dictionary<String, Any>{
                if let name = data[Constants.NAME] as? String {
                    if name == self.driver{
                        if let lat = data[Constants.LATITUDE] as? Double{
                            if let long = data[Constants.LONGITUDE] as? Double {
                                self.deleagte?.updateDriversLocation(lat: lat, long: long)
                            }
                        }
                        self.deleagte?.driverAcceptedRequest(requestAccepted: false, driverName: name)
                    }
                }
            }
        })
        
    }
    
    func requestUber(latitude: Double , longtitude : Double ){
        print(rider)
        let data: [String : Any ] = [Constants.LATITUDE :latitude , Constants.LONGITUDE: longtitude, Constants.NAME : self.rider ]
        DBProvider.Instance.requestRef.childByAutoId().setValue(data)
    }// reuqest Uber
    

    func cancelUber() {
        DBProvider.Instance.requestRef.child(rider_id).removeValue()
    }    //cancel uber
    
    func updateRidersLocation(lat:Double , long:Double){
        DBProvider.Instance.requestRef.child(rider_id).updateChildValues([Constants.LATITUDE: lat, Constants.LONGITUDE:long])
    }
    
} // uber handler class
