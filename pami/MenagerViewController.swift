//
//  MenagerViewController.swift
//  pami
//
//  Created by Pawel  on 2018-06-12.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit

class MenagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var employees:[User] = []
    var activeShifts:[ClockedShift] = []
    var activeIds:[String]=[]
    var df = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        employees = FirebaseController.employees
        _ = FirebaseController.getActiveShifts().subscribe { (event) in
            self.activeShifts = event.element!
            self.activeIds = []
            self.activeShifts.forEach({ (clockedShift) in
                self.activeIds.append(clockedShift.employeeId)
            })
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenagerTableViewCell
        
        if(activeIds.contains(employees[indexPath.row].employeeId)){
            
            cell.backgroundColor = UIColor(named: "primaryColor")
            cell.nameLabel.textColor = UIColor.white
            cell.timeLabel.textColor = UIColor.white
            cell.checkMark.isHidden = false
            cell.checkMark.image = cell.checkMark.image!.withRenderingMode(.alwaysTemplate)
            cell.checkMark.tintColor = UIColor.white
        
            
            activeShifts.forEach { (activeShift) in
                if(activeShift.employeeId == employees[indexPath.row].employeeId){
                    df.dateFormat = "MM/dd HH:mm"
                    cell.timeLabel.text = df.string(from: activeShift.startDate)
                }
            }
        }else{
            cell.backgroundColor = UIColor.white
            cell.nameLabel.textColor = UIColor(named: "mainGray")
            cell.timeLabel.textColor = UIColor(named: "mainGray")
            cell.checkMark.isHidden = true
            cell.timeLabel.text = ""
        }
        cell.nameLabel.text = employees[indexPath.row].firstName + " " + employees[indexPath.row].lastName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let employee = employees[indexPath.row]
        
        if(activeIds.contains(employee.employeeId)){
            let alertView = UIAlertController(title: employee.firstName + " " + employee.lastName, message: String(employee.socialSecurityNumber), preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Avbryt", style: .destructive) { (action) in
                
            }
            let accept = UIAlertAction(title: "Stämpla Ut", style: UIAlertActionStyle.default) { (action) in
                
                
                for var shift in self.activeShifts {
                    if(shift.employeeId == self.employees[indexPath.row].employeeId){
                        shift.messageOut = "Utstämplad utav " + FirebaseController.user.firstName + " " + FirebaseController.user.lastName
                        shift.endDate = Date()
                        FirebaseController.clockOutShift(clockShift: shift)
                    }
                }
            }
            alertView.addAction(cancel)
            alertView.addAction(accept)
            
            present(alertView, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: false)
            
        }else{
            
            let alertView2 = UIAlertController(title: employee.firstName + " " + employee.lastName, message: String(employee.socialSecurityNumber), preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Avbryt", style: .destructive) { (action) in
                
            }
            let accept = UIAlertAction(title: "Stämpla In", style: UIAlertActionStyle.default) { (action) in
                var clockInShift = ClockedShift()
                clockInShift.employeeId = employee.employeeId
                clockInShift.firstName = employee.firstName
                clockInShift.lastName = employee.lastName
                clockInShift.messageIn = "instämplad av " + FirebaseController.user.firstName + " " + FirebaseController.user.lastName
                clockInShift.startDate =  Date()
                FirebaseController.clockInShift(clockInShift: clockInShift)
            }
            alertView2.addAction(cancel)
            alertView2.addAction(accept)
            present(alertView2, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}
