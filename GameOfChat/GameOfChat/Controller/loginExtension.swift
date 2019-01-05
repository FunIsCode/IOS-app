//
//  loginExtension.swift
//  GameOfChat
//
//  Created by yuanqi on 2018/9/22.
//  Copyright © 2018 yuanqi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Firebase

 
extension LoginController :UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
 

    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let uid = user?.user.uid else {
                return
            }
            
            //successfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
    
              if let profileImage = self.profileImageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.1) {

//            if let uploadData = self.profileImageView.image!.pngData() {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if let error = error {
                        print("error is \(error)")
                        return
                    }
                    print("metadata \(metadata!)   //")
//                    var url = self.root_url + storageRef.fullPath
                    storageRef.downloadURL { (url, error) in
//                        guard let downloadURL = url else {
//                            print("Error :\(String(describing: error))")
//                        return
//                        }
                        if let URL = url?.absoluteString {
                            let values = ["name": name, "email": email, "profileImageUrl": URL]
                            self.registerUserIntoDatabaseWithUID(uid, values: values as [String : String])
                        }
                        

                    }
                })
            }
        })
    }
    
    private func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: String]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
//                     self.messagesController?.fetchUserAndSetupNavBarTitle()
            //            self.messagesController?.navigationItem.title = values["name"] as? String
            let user = User(dictionary: values)
            self.messagesController?.setupNavBarWithUser(user)

            
            
            self.dismiss(animated: true, completion: nil)
        })
    }
  
  
 
    @objc func handleSelectProfileImageView(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker,animated: true ,completion:  nil)
    }
  
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey  : Any]) {
        var selectedImageFromPicker: UIImage?
            if let editedImage = info[.editedImage] as? UIImage {
                selectedImageFromPicker = editedImage
    
            } else if let originalImage = info[.originalImage] as? UIImage  {
    
                selectedImageFromPicker = originalImage
            }
    
            if let selectedImage = selectedImageFromPicker  {
                print(selectedImage.size)
                profileImageView.image = selectedImage
            }
    

        dismiss(animated: true, completion: nil)
      
    }
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)

    }
}

