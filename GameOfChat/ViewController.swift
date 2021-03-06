////
////  ViewController.swift
////  GameOfChat
////
////  Created by yuanqi on 2018/9/20.
////  Copyright © 2018 yuanqi. All rights reserved.
////
//
//import UIKit
//import Firebase
//import FirebaseAuth
//
//class ViewController: UITableViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        checkIfUserIsLogIN()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleMessage))
//
//    }
//
//    @objc func handleMessage(){
//        let newMessageController = NewMessageController()
//        let nacController = UINavigationController(rootViewController: newMessageController)
//        self.present(nacController, animated: true, completion: nil)
//
//
//    }
//
//    func checkIfUserIsLogIN(){
//        if Auth.auth().currentUser?.uid == nil {
//            perform(#selector(handleLogout), with: nil, afterDelay: 0)
//        }else{
//          fetchUserAndSetupNavBarTitle()
//        }
//    }
//
//
//
//    func fetchUserAndSetupNavBarTitle() {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            //for some reason uid = nil
//            return
//        }
//
//        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//
//            if let dictionary = snapshot.value as? [String: String] {
//                let user = User(dictionary: dictionary)
//                self.setupNavBarWithUser(user)
//            }
//
//        }, withCancel: nil)
//    }
//
//    func setupNavBarWithUser(_ user: User) {
//        let titleView = UIView()
//        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//        //        titleView.backgroundColor = UIColor.redColor()
//
//        let containerView = UIView()
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        titleView.addSubview(containerView)
//
//        let profileImageView = UIImageView()
//        profileImageView.translatesAutoresizingMaskIntoConstraints = false
//        profileImageView.contentMode = .scaleAspectFill
//        profileImageView.layer.cornerRadius = 20
//        profileImageView.clipsToBounds = true
//        if let profileImageUrl = user.profileImageUrl {
//            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
//        }
//
//        containerView.addSubview(profileImageView)
//
//        //ios 9 constraint anchors
//        //need x,y,width,height anchors
//        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        let nameLabel = UILabel()
//
//        containerView.addSubview(nameLabel)
//        nameLabel.text = user.name
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        //need x,y,width,height anchors
//        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
//        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
//        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
//
//        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
//        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
//
//        self.navigationItem.titleView = titleView
//    }
//
//
//
//    @objc func handleLogout() {
//
//        do {
//            try Auth.auth().signOut()
//            self.navigationItem.title = ""
//
//
//        } catch let logoutError {
//            print(logoutError)
//        }
//
//        let loginController = LoginController()
//        present(loginController, animated: true, completion: nil)
//    }
//
//
//
//}
//
//
