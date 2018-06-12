//
//  ClockViewController.swift
//  pami
//
//  Created by Pawel  on 2018-06-12.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit

class ClockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var activeShifts:[ClockedShift] = []
    var df = DateFormatter()
    var userIsActive = false
    
    @IBOutlet weak var messageField: UITextField!

    @IBOutlet weak var clockOutBtn: UIButton!
    @IBOutlet weak var clockInBtn: UIButton!
    
    @IBAction func onClockOut(_ sender: Any) {
        print("zzzz")
        clockOutBtn.isEnabled = false

        for var actS in activeShifts{
            if(actS.employeeId == FirebaseController.user.employeeId){
                actS.messageOut = messageField.text!
                actS.timeStempOut = Int(Date().timeIntervalSince1970)
                
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
        clockedShift.timeStempIn = Int(Date().timeIntervalSince1970)
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
            if(self.userIsActive){
                self.clockOutBtn.isEnabled = true
                self.clockInBtn.isEnabled = false
                self.clockOutBtn.backgroundColor = UIColor(named: "primaryColor")
                self.clockInBtn.backgroundColor = UIColor.lightGray
            }else{
                self.clockOutBtn.isEnabled = false
                self.clockInBtn.isEnabled = true
                self.clockOutBtn.backgroundColor = UIColor.lightGray
                self.clockInBtn.backgroundColor = UIColor(named: "primaryColor")
            }
            
            self.tableView.reloadData()
        }
        df.dateFormat = "HH:mm"
        
        tableView.delegate = self
        tableView.dataSource = self
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
        cell.time.text = self.df.string(for: Date(timeIntervalSince1970: Double(activeShifts[indexPath.row].timeStempIn)))
        
        return cell
    }
    
}
