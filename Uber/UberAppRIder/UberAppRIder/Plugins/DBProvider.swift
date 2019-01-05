//
//  DBProvider.swift
//  UberAppRIder
//
//  Created by yuanqi on 2018/9/9.
//  Copyright © 2018 yuanqi. All rights reserved.
//

import Foundation
import Firebase




class DBProvider{
    private static let _instance = DBProvider()
    
    static var Instance :DBProvider {
        return _instance
    }
    
    var dbRef :DatabaseReference {
        return Database.database().reference()
    }
    
    var ridersRef : DatabaseReference{
        return dbRef.child(Constants.RIRDERS)
    }
    
    var requestRef : DatabaseReference{
        return dbRef.child(Constants.UBER_REQUEST)
    }
    
    var reuqestAcceptedRef :DatabaseReference {
        return dbRef.child(Constants.UBER_ACCEPTED)
    }
    
//    request ref
    
    
    
    
    //reuqest Accepted
    func saveUser(withID: String , email :String , password : String ) {
        let data :  [String : Any]  = [Constants.EMAIL:email ,  Constants.PASSWORD : password ,Constants.isRider :true ]
        ridersRef.child(withID).child(Constants.DATA).setValue(data)
        
        
        
    }
    
    
}
