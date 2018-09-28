//
//  SettingsViewController.swift
//  pami
//
//  Created by Pawel  on 2018-06-17.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var faceBookBtn: UIButton!
    
    @IBAction func onLogOutClicked(_ sender: Any) {
        print("logout")
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Settings View Controller Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func onFacebookClicked(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logOutBtn.layer.backgroundColor = UIColor.white.cgColor
        logOutBtn.layer.borderColor = UIColor(named: "primaryDark")?.cgColor
        logOutBtn.layer.borderWidth = 1
        logOutBtn.setTitleColor(UIColor(named: "primaryDark"), for: .normal)
        logOutBtn.layer.cornerRadius = 5
        
        
        faceBookBtn.layer.backgroundColor = UIColor.white.cgColor
        faceBookBtn.layer.borderColor = UIColor.blue.cgColor
        faceBookBtn.layer.borderWidth = 1
        faceBookBtn.setTitleColor(UIColor.blue, for: .normal)
        faceBookBtn.layer.cornerRadius = 5
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user == nil){
                 self.performSegue(withIdentifier: "logout", sender: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
