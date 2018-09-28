//
//  ViewController.swift
//  pami
//
//  Created by Pawel  on 2018-05-31.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
 
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var bg: UIView!
    

    @IBAction func onForgotClicked(_ sender: Any) {
         performSegue(withIdentifier: "forgot", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        Auth.auth().addStateDidChangeListener { (auth, user) in
        
            if(user != nil){
                FirebaseController.setUpUser().subscribe{ isSetUp in
                    if isSetUp.element! {
                        self.performSegue(withIdentifier: "nana", sender: self)
                    }
                    
                }
            }
        }
      
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "forgot"){
            var weekController = segue.destination as! ForgotViewController
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        passwordField.borderStyle = .none
        emailField.borderStyle = .none
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClick(_ sender: Any) {
        
        if let e = emailField.text,let p = passwordField.text{
            Auth.auth().signIn(withEmail:e,password:p){(user,error) in
                if(user != nil){
                   
                }
            }
        }
    }
}

