

import Foundation
import Firebase
//driver


class DBProvider{
    private static let _instance = DBProvider()
    
    static var Instance :DBProvider {
        return _instance
    }
    
    var dbRef :DatabaseReference {
        return Database.database().reference()
    }
    
//    driver database
    var driversRef : DatabaseReference{
        return dbRef.child(Constants.DRIVERS)
    }
    
    //    request ref
    var requestRef : DatabaseReference{
        return dbRef.child(Constants.UBER_REQUEST)
    }
    
    
    
        //reuqest Accepted
    var requestAcceptedRef :DatabaseReference{
        return  dbRef.child(Constants.UBER_ACCEPTED)
    }
    
    

    
    func saveUser(withID: String , email :String , password : String ) {
        let data :  [String : Any]  = [Constants.EMAIL:email ,  Constants.PASSWORD : password ,Constants.isRider :false ]
        driversRef.child(withID).child(Constants.DATA).setValue(data)
   
    }  
}
