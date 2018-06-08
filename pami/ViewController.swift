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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
      
        
    }
    override func viewDidLayoutSubviews() {
        passwordField.borderStyle = .none
        emailField.borderStyle = .none
        
//        let border = CALayer()
//        let width =  CGFloat(2.0)
//        border.borderColor = UIColor.darkGray.cgColor
//        border.frame = CGRect(x: 0, y: passwordField.frame.size.height - width, width: passwordField.frame.width, height: passwordField.frame.size.height)
//        
//        border.borderWidth = width
//        passwordField.layer.addSublayer(border)
//        passwordField.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClick(_ sender: Any) {
        
        if let e = emailField.text,let p = passwordField.text{
            Auth.auth().signIn(withEmail:e,password:p){(user,error) in
                if(user != nil){
                    FirebaseController.setUpUser().subscribe{ isSetUp in
                        if isSetUp.element! {
                            self.performSegue(withIdentifier: "nana", sender: self)
                        }
                        
                    }
                }
            }
        }
    }
}

