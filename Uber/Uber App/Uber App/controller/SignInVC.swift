//
//  SignInVC.swift
//  Uber App
//
//  Created by yuanqi on 2018/9/9.
//  Copyright © 2018 yuanqi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
// driver
class SignInVC: UIViewController {

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
    
    @IBAction func logInAction(_ sender: UIButton) {
        if EmailTextField.text != "" && PasswordTextField.text != ""{
            AuthProvider.Instance.login(withEmail: EmailTextField.text!, password: PasswordTextField.text!, LoginHandler:{(message) in
                if message != nil{
                    self.alerTheUser(title: "Problem with Authentication", message: message!)
                    print(message as Any)
                }else{
                    UberHandler.Instance.driver = self.EmailTextField.text!
                    self.EmailTextField.text = ""
                    self.PasswordTextField.text = ""
                    self.performSegue(withIdentifier: "DriverVC", sender:self)
                    print("LOG IN COMPLETED")
                }
            })
        }
 
    }
    
    @IBAction func SignUpAction(_ sender: UIButton) {
        if EmailTextField.text != "" && PasswordTextField.text != ""{
            AuthProvider.Instance.signUp(withEmail: EmailTextField.text!, password: PasswordTextField.text!,  LoginHandler:{(message) in
                if message != nil{
                    self.alerTheUser(title: "Problem with Creating A New User", message: message!)
                }else{
//                    UberHandler.Instance.driver = self.EmailTextField.text!
                    self.EmailTextField.text = ""
                    self.PasswordTextField.text = ""
//                 self.performSegue(withIdentifier: "DriverVC", sender:self)
                    print("Created User COMPLETED")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
