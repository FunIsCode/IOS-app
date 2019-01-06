//
//  AuthProvider.swift
//  UberAppRIder
//
//  Created by yuanqi on 2018/9/9.
//  Copyright © 2018 yuanqi. All rights reserved.
//

import Foundation
import FirebaseAuth
//rider



typealias LoginHandler = (_ msg :String?) -> Void // function


struct LoginErrorCode{
    static let INVALID_EMAIL = "Invalid Email Address, Please Provide A Real Email Address"
    static let WRONG_PASSWORD = "Wrong Password, Please Enter Correct Password"
    static let USER_NOT_FOUND = "User Not Found, Please Register"
    static let EMAIL_ALREADY_IN_USE = "Email Already In User,Please Use Another Email"
    static let WEAK_PASSWORD = "Password Should Be At Least 6 Characters Long"
    static let PROBLEM_CONNECTING = "Problem Connection To Database"
}// struct



class AuthProvider{
    private static let _instance = AuthProvider()
    
    static var Instance : AuthProvider {
        return _instance
    }// Instance
    func signUp(withEmail: String, password:String, LoginHandler:LoginHandler?){
        Auth.auth().createUser(withEmail: withEmail, password: password, completion: {(user, error) in
            if error != nil {
                self.handleErrors(err: error! as NSError, LoginHandler: LoginHandler)
            }else{
                if user?.user.uid != nil{
                    //store the user to databse
                    DBProvider.Instance.saveUser(withID: (user?.user.uid)!, email: withEmail, password: password)
                    
                    //store the user to database
                    self.login(withEmail: withEmail, password: password, LoginHandler: LoginHandler)
                }
            }
        })
    }//func signup
    
    
    func login(withEmail: String, password:String, LoginHandler:LoginHandler?){
        Auth.auth().signIn(withEmail: withEmail, password: password ,completion:{ (user, error) in
            if error != nil {
                self.handleErrors(err: error! as NSError, LoginHandler: LoginHandler)
            }
            else{
                LoginHandler?(nil)
            }
        })

    }// login func
    
    
    func logout() -> Bool{
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                return true
            }catch{
                return false
            }
        }
        return true
    }//log out func
    
    
    // handle the error when sign in
    private func handleErrors(err:NSError , LoginHandler:LoginHandler?){
        if let errCode = AuthErrorCode(rawValue : err.code){
            switch errCode{
            case .wrongPassword:
                LoginHandler?(LoginErrorCode.WRONG_PASSWORD) // Transform to wrongPassword
            case .invalidEmail:
                LoginHandler?(LoginErrorCode.INVALID_EMAIL)
            case .userNotFound:
                LoginHandler?(LoginErrorCode.USER_NOT_FOUND)
            case .emailAlreadyInUse:
                LoginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE)
            case .weakPassword:
                LoginHandler?(LoginErrorCode.WEAK_PASSWORD)
            default:
                LoginHandler?(LoginErrorCode.PROBLEM_CONNECTING)
            }
        }
    }//handleErrors func
    
}//class
