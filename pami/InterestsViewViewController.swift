//
//  InterestsViewViewController.swift
//  pami
//
//  Created by Pawel  on 2018-06-11.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit


class InterestsViewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var shiftsToTake:[ShiftToTake] = []
    var df = DateFormatter()
    var interests:[Interest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        tableView.delegate = self
        tableView.dataSource = self
        
        FirebaseController.getShiftsToTake().subscribe { (event) in
            self.shiftsToTake = event.element!
            self.tableView.reloadData()
            
            FirebaseController.getInterests().subscribe({ (event) in
                
                self.interests = event.element!.filter({ (inter) -> Bool in
         
                    return inter.employeeId == FirebaseController.user.employeeId
                })
                self.tableView.reloadData()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shiftsToTake.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InterestsTableViewCell
        df.dateFormat = "dd MMM"
        cell.dateLabel.text = df.string(from: shiftsToTake[indexPath.row].startDate)
        df.dateFormat = "HH:mm"
        cell.timeLabel.text = df.string(from: shiftsToTake[indexPath.row].startDate) + "-" + df.string(from: shiftsToTake[indexPath.row].endDate)
        cell.departmentLabel.text =  shiftsToTake[indexPath.row].departmentName
        
        cell.switcher.setOn(false, animated: true)
        cell.layer.backgroundColor  = UIColor.white.cgColor
        interests.forEach { (inter) in
            if(shiftsToTake[indexPath.row].id == inter.shiftToTakeId){
                cell.switcher.setOn(true, animated: true)
               cell.backgroundColor = UIColor(named: "lightGray")
            }
        }
        cell.switcher.addTarget(self, action: #selector(InterestsViewViewController.connected(sender:)), for: .touchUpInside)
        cell.switcher.tag = indexPath.row
        
        return cell
    }
    
    @objc func connected(sender:UISwitch){
        let index = Int(sender.tag)
        let id = shiftsToTake[index].id

        if(sender.isOn){
            FirebaseController.addInterest(interest: [
                "shiftToTakeId":id,
                "employeeId":FirebaseController.user.employeeId,
                "dateAdded": Date(),
                "startDate": shiftsToTake[index].startDate,
                "endDate":shiftsToTake[index].endDate,
                "department": shiftsToTake[index].departmentName
                ])
        }else{
            interests.forEach { (inter) in
                if(inter.shiftToTakeId == id){
                     FirebaseController.removeInterest(id: inter.interestId)
                }
            }
           
        }
    }
    

}
