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
//
//        var img = UIImage(named: "moon2")
//        var iv = UIImageView(image: img)
//
//        iv.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
//
//        iv.center = self.view.center
//
//        self.view.insertSubview(iv, at: 1)
//
//        let gradient: CAGradientLayer = CAGradientLayer()
//
//        gradient.colors = [UIColor(named: "pamiOrange")?.cgColor, UIColor(named: "pamiRed")?.cgColor]
//        gradient.locations = [0.0 , 1.0]
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
//        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
//        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//
//
//        self.view.layer.insertSublayer(gradient, at: 0)
//        

        
      
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "forgot"){
            var weekController = segue.destination as! ForgotViewController
            
        }
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

