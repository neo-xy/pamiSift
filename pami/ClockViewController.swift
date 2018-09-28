//
//  ClockViewController.swift
//  pami
//
//  Created by Pawel  on 2018-06-12.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

class ClockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var activeShifts:[ClockedShift] = []
    var df = DateFormatter()
    var userIsActive = false
    
    @IBOutlet weak var messageField: UITextField!

    @IBOutlet weak var clockOutBtn: UIButton!
    @IBOutlet weak var clockInBtn: UIButton!
    
    @IBAction func onClockOut(_ sender: Any) {
        clockOutBtn.isEnabled = false

        for var actS in activeShifts{
            if(actS.employeeId == FirebaseController.user.employeeId){
                actS.messageOut = messageField.text!
                actS.endDate = Date()
                var shiftLog = ShiftLog()
                shiftLog.shiftStatus = ShiftStatus.ClockedOut.rawValue
                shiftLog.startDate = actS.startDate
                shiftLog.endDate = actS.endDate
                shiftLog.bossId = FirebaseController.user.employeeId
                shiftLog.bossFirstName = FirebaseController.user.firstName
                shiftLog.bossLastName = FirebaseController.user.lastName
                shiftLog.bossSocialNumber = FirebaseController.user.socialSecurityNumber
                shiftLog.date = actS.endDate
                actS.logs = [shiftLog]
                
                self.messageField.text = ""
                FirebaseController.clockOutShift(clockShift: actS)
                userIsActive = false
            }
        }
    }
    
    @IBAction func onClockIn(_ sender: Any) {
        clockInBtn.isEnabled = false
        var clockedShift = ClockedShift()
        clockedShift.employeeId = FirebaseController.user.employeeId
        clockedShift.startDate = Date()

        clockedShift.messageIn = messageField.text!
        clockedShift.firstName = FirebaseController.user.firstName
        clockedShift.lastName = FirebaseController.user.lastName
        
        FirebaseController.clockInShift(clockInShift: clockedShift)
        messageField.text = ""
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        clockInBtn.isEnabled = false
        clockOutBtn.isEnabled = false
        clockInBtn.backgroundColor = UIColor.lightGray
        clockOutBtn.backgroundColor = UIColor.lightGray
        tableView.delegate = self
        tableView.dataSource = self
        
        print("1111")
        
       var ssid =  getWifiSSid()
        messageField.layer.borderColor = UIColor(named: "primaryDark")?.cgColor
        messageField.layer.borderWidth = 1
        messageField.layer.cornerRadius = 5
        
        _ = FirebaseController.getActiveShifts().subscribe { (event) in
            self.activeShifts = event.element!
            self.activeShifts.forEach({ (activeShift) in
                if(activeShift.employeeId == FirebaseController.user.employeeId){
                    self.userIsActive = true
                }
            })
            
              print("00000")
            if(self.userIsActive){
                  print("222221")
                self.clockOutBtn.isEnabled = true
                self.clockInBtn.isEnabled = false
                self.clockOutBtn.backgroundColor = UIColor(named: "primaryColor")
                self.clockInBtn.backgroundColor = UIColor.lightGray
            }else{
                  print("33333")
                self.clockOutBtn.isEnabled = false
                self.clockInBtn.isEnabled = true
                self.clockOutBtn.backgroundColor = UIColor.lightGray
                self.clockInBtn.backgroundColor = UIColor(named: "primaryColor")
            }
            self.tableView.reloadData()
        }
        df.dateFormat = "HH:mm"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeShifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ClockTableViewCell
        cell.name.text = activeShifts[indexPath.row].firstName + " " + activeShifts[indexPath.row].lastName
        cell.time.text = self.df.string(for:activeShifts[indexPath.row].startDate)
        return cell
    }
    
    func getWifiSSid() -> String{
        var ssid:String = "rr"
        print("hhhhhhhhhhhhh")
        if let interfaces = CNCopySupportedInterfaces() as NSArray?{
            print("if")
            for interdace in interfaces{
                print("for" + (interdace as! String) )
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interdace as! CFString) as NSDictionary?{
                    ssid = (interfaceInfo[kCNNetworkInfoKeySSID as String] as? String)!
                    var rr = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String
                    print("eee "+rr!)
                    break
                }
            }
        }
        return ssid
    }
}
