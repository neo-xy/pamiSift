//
//  ForgotViewController.swift
//  pami
//
//  Created by Pawel  on 2018-06-16.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func onResetPasswordClicked(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: email.text!) { (error) in
            
            if(error == nil){
                let alertView = UIAlertController(title: "E-post skickades",message:nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .destructive) { (action) in}
                
                alertView.addAction(cancel)
                self.present(alertView, animated: true, completion: nil)
            }else{
                let alertView = UIAlertController(title: "Fel upstog, försök igen",message:nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Ok", style: .destructive) { (action) in
                    
                }
                alertView.addAction(cancel)
                self.present(alertView, animated: true, completion: nil)
            }
        } 
    }
}
