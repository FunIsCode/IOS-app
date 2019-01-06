//
//  SigninVC.swift
//  UberAppRIder
//
//  Created by yuanqi on 2018/9/9.
//  Copyright © 2018 yuanqi. All rights reserved.
//

import UIKit
//rider
class SigninVC: UIViewController {

    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginaction(_ sender: UIButton) {
//         self.performSegue(withIdentifier: "RiderVC", sender:self)
        if EmailTextField.text != "" && PasswordTextField.text != ""{
            AuthProvider.Instance.login(withEmail: EmailTextField.text!, password: PasswordTextField.text!, LoginHandler:{(message) in
                if message != nil{
                    self.alerTheUser(title: "Problem with Authentication", message: message!)
                    print(message as Any)
                }else{
                    UberHandler.Instance.rider = self.EmailTextField.text!
                    self.EmailTextField.text = ""
                    self.PasswordTextField.text = ""
                    self.performSegue(withIdentifier: "RiderVC", sender:self)
                    print("LOG IN COMPLETED")
                }
            })
        }else{
            alerTheUser(title: "Email And Password Are Required:", message: "Please Enter Email and Password")
        }

    }
    
    private func alerTheUser(title :String , message :String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }  //alerTheUser func
    
    
    @IBAction func signupaction(_ sender: UIButton) {
        if EmailTextField.text != "" && PasswordTextField.text != ""{
            AuthProvider.Instance.signUp(withEmail: EmailTextField.text!, password: PasswordTextField.text!,  LoginHandler:{(message) in
                if message != nil{
                    self.alerTheUser(title: "Problem with Creating A New User", message: message!)
                }else{
//                    self.performSegue(withIdentifier: "RiderVC", sender:self)
                    UberHandler.Instance.rider = self.EmailTextField.text!
                    self.EmailTextField.text = ""
                    self.PasswordTextField.text = ""
                    print("Created User COMPLETED")
                    self.alerTheUser(title: "Created User COMPLETED", message:"Created User COMPLETED" )
                }
                })
        }else{
                 alerTheUser(title: "Email And Password Are Required:", message: "Please Enter Email and Password")
        }
    }
    
}//class







