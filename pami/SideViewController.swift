//
//  SideViewController.swift
//  pami
//
//  Created by Pawel  on 2018-06-03.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit
import FirebaseAuth


class SideViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sideMenuGradient: UIView!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    let menu = ["Hem","Schema","Tider","Mina info","Kontakter","Hantera passen","Logga ut"]
    
    @IBOutlet weak var myTable: UITableView!
    let icons = ["home_ic","calendar_ic","time_card_ic","info_ic","contacts_ic","users_ic","logout_ic"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "sideMenuRow")
        
        cell.imageView?.image = UIImage(named: icons[indexPath.row])
        cell.tintColor = UIColor.cyan
        cell.imageView?.tintColor = UIColor.blue
        cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = UIColor(named: "mainGray")
        
        
        cell.textLabel?.text = menu[indexPath.row]
        cell.textLabel?.textColor = UIColor(named: "mainGray")
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        setUpGradien()
        
        let ur = URL(string: FirebaseController.user.imgUrl)
        let data = try? Data(contentsOf: (Auth.auth().currentUser?.providerData[0].photoURL)!)
        let defaultData = try? Data(contentsOf: ur!)
        
        if let imgd = data{
            print("ifffffffff")
            userImg.image = UIImage(data: imgd)
        }else{
            print("else")
            if let ggg = defaultData{
                print("iff22222")
                userImg.image = UIImage(data: ggg)
            }
            
            
        }
        userImg.layer.borderWidth = 1
        userImg.layer.masksToBounds =  false
        userImg.layer.borderColor = UIColor.gray.cgColor
        userImg.layer.cornerRadius = userImg.frame.height/2
        userImg.clipsToBounds = true
        
        userNameLabel.text = FirebaseController.user.firstName + " " + FirebaseController.user.lastName
        companyNameLabel.text = FirebaseController.user.companyName
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpGradien(){
        let gradien:CAGradientLayer = CAGradientLayer()
        gradien.frame.size = sideMenuGradient.frame.size
        gradien.colors = [UIColor(named: "gradienStart"),UIColor(named: "primaryDark")?.cgColor ,UIColor(named: "primaryColor")]
        gradien.startPoint = CGPoint(x: 0.0, y: 0)
        gradien.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradien.locations = [0.0,1.0]
        
        sideMenuGradient.layer.insertSublayer(gradien, at: 0)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
