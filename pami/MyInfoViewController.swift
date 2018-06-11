//
//  MyInfoViewController.swift
//  pami
//
//  Created by Pawel  on 2018-06-08.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit

class MyInfoViewController: UIViewController {
    
    @IBOutlet weak var bank: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var socialNumber: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var lastWorkDay: UILabel!
    @IBOutlet weak var firstWorkDay: UILabel!
    @IBOutlet weak var currentSalary: UILabel!
    @IBOutlet weak var totalSalary: UILabel!
    @IBOutlet weak var totalWorkedHours: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    
    var user:User!
    var acceptedShifts:[Shift]!
    var df = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.isNavigationBarHidden = true
        
        user = FirebaseController.user;
        let imgUrl =  user.imgUrl
        
        let url = URL(string: imgUrl)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        profileImgView.image = UIImage(data: data!)
        profileImgView.layer.cornerRadius = profileImgView.frame.width/2
        profileImgView.clipsToBounds = true
        
        userNameLabel.text = user.firstName + " " + user.lastName
        phone.text = user.phoneNumber
        print(user.address)
        address.text = user.address
        socialNumber.text = String(user.socialSecurityNumber)
        email.text = user.email
        bank.text = user.accountNr + ", " + user.bankName
      
         _ = FirebaseController.getAcceptedShifts().subscribe { (event) in
            print("jjjj")
            self.acceptedShifts =  event.element
            
            print(self.acceptedShifts.count)
            
            self.totalWorkedHours.text  = self.getWorkedHours() + " timmar"
            self.totalSalary.text = self.getTotalSalary() + " Sek/tim"
            
            self.sortShiftsByDate()
            self.df.dateFormat = "dd MMM yyyy"
            self.df.locale = Locale(identifier: "sv")
            
            self.firstWorkDay.text = self.df.string(from: self.acceptedShifts[0].startDate)
            self.lastWorkDay.text = self.df.string(from: self.acceptedShifts[self.self.acceptedShifts.count-1].startDate)
            
        }
    }
    
    func getWorkedHours() -> String{
        var sumHours = 0.0
        self.acceptedShifts.forEach { (shift) in
            sumHours = sumHours + shift.duration
        }
    return String(sumHours)
    }
    
    func getTotalSalary() -> String{
        var sumSalary = 0
        self.acceptedShifts.forEach { (shift) in
            sumSalary = shift.basePay + shift.OBmoney + shift.OBnattMoney
        }
        return String(sumSalary)
    }
    
    func sortShiftsByDate() {
       acceptedShifts.sort { (a, b) -> Bool in
            return a.startDate > b.startDate
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
