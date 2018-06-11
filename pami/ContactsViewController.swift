//
//  ContactsViewController.swift
//  pami
//
//  Created by Pawel  on 2018-06-09.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

 
    
    @IBOutlet weak var contactsTable: UITableView!
    var employees:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        employees = FirebaseController.employees
        employees.sort { (a, b) -> Bool in
            return a.firstName < b.firstName
        }
        
        employees.sort { (a, b) -> Bool in
            return a.role < b.role
        }
        
        contactsTable.delegate = self
        contactsTable.dataSource = self
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          print("employees \(employees.count)")
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cel = contactsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactTableViewCell
        cel.emailBtn.setTitle(employees[indexPath.row].email, for: .normal)
        cel.phoneBtn.setTitle(employees[indexPath.row].phoneNumber, for: .normal)
        cel.nameLabel.text = employees[indexPath.row].firstName + " " + employees[indexPath.row].lastName
        
        
        if(employees[indexPath.row].role == "boss"){
            cel.contactRect.layer.backgroundColor = UIColor(named: "primaryColor")?.cgColor
            cel.emailBtn.setTitleColor(UIColor.white, for: .normal)
            cel.phoneBtn.setTitleColor(UIColor.white, for: .normal)
            cel.nameLabel.textColor = UIColor.white
            cel.phoneLabel.textColor = UIColor.white
            cel.emailLabel.textColor = UIColor.white
        
            
        }else{
            cel.contactRect.layer.backgroundColor = UIColor.white.cgColor
            cel.contactRect.layer.borderWidth = 1
            cel.contactRect.layer.borderColor = UIColor.gray.cgColor
            
            cel.emailBtn.setTitleColor(UIColor.gray, for: .normal)
            cel.phoneBtn.setTitleColor(UIColor.gray, for: .normal)
            cel.nameLabel.textColor = UIColor.gray
            cel.phoneLabel.textColor = UIColor.gray
            cel.emailLabel.textColor = UIColor.gray
        
        }
        
        
        cel.contactRect.layer.cornerRadius = 6
        
         cel.contactRect.layer.masksToBounds = false
         cel.contactRect.layer.shadowColor = UIColor.gray.cgColor
         cel.contactRect.layer.shadowOpacity = 1
         cel.contactRect.layer.shadowOffset = CGSize(width: -1, height: 1)
         cel.contactRect.layer.shadowRadius = 6
        
         cel.contactRect.layer.shadowPath = UIBezierPath(rect: cel.contactRect.self.bounds).cgPath
         cel.contactRect.layer.shouldRasterize = true
         cel.contactRect.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        return cel
       
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
