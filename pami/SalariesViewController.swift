//
//  SalariesViewController.swift
//  pami
//
//  Created by Pawel  on 2018-06-11.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit

class SalariesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var currentMonthLabel: UILabel!
    var acceptedShifts:[Shift] = []
    var now = Date()
    var df = DateFormatter()
    var currentShifts:[Shift] = []
    var calNow = Calendar.current
    
    var monthTotalHours = 0.0
    var monthTotalPay = 0
    var monthTotalNetto = 0
    var monthTotalBrutto = 0
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        df.dateFormat = "MMMM"
        df.locale = Locale(identifier: "sv")
        currentMonthLabel.text = df.string(from: now)
        
        _ = FirebaseController.getAcceptedShifts().subscribe { (event) in
            self.acceptedShifts = event.element!
            self.setUpCurrentShifts(date: self.now)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count \(currentShifts.count)")
      
        return (currentShifts.count + 2)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cel = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! salaryTableViewCell
        
        if((currentShifts.count ) == indexPath.row){
            print("-2")
            cel.dayCell.text = ""
            cel.startCell.text = ""
            cel.endCell.text = ""
            cel.durationCell.text = String(self.monthTotalHours)
            cel.payCell.text = ""
            cel.durationCell.font = UIFont.boldSystemFont(ofSize: 16.0)
            cel.payCell.font = UIFont.boldSystemFont(ofSize: 16.0)
        } else if((currentShifts.count + 1) == indexPath.row){
            print(-1)
            cel.dayCell.text = ""
            cel.endCell.text = ""
            cel.startCell.text = ""
            cel.durationCell.text = "Netto"
            cel.payCell.text = String(self.monthTotalNetto)
            cel.durationCell.font = UIFont.boldSystemFont(ofSize: 16.0)
              cel.payCell.font = UIFont.boldSystemFont(ofSize: 16.0)
        }else{
            print("else \(indexPath.row)")
            df.dateFormat = "dd"
            cel.dayCell.text = df.string(from: currentShifts[indexPath.row].startDate)
            
            cel.durationCell.text = String(currentShifts[indexPath.row].duration)
            df.dateFormat = "HH:mm"
            cel.startCell.text = df.string(from: currentShifts[indexPath.row].startDate)
            cel.endCell.text = df.string(from: currentShifts[indexPath.row].endDate)
//            cel.payCell.text = String(currentShifts[indexPath.row].OBmoney + currentShifts[indexPath.row].OBnattMoney + currentShifts[indexPath.row].basePay)
            cel.payCell.text = String(currentShifts[indexPath.row].netto)
            cel.durationCell.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            cel.payCell.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        }
        
     
        
        return cel
    }
    
    func setUpCurrentShifts(date:Date){
        currentShifts = []
        monthTotalNetto = 0
        monthTotalHours = 0.0
        monthTotalPay = 0
        monthTotalBrutto = 0
        
        let calNowMonth =   calNow.component(Calendar.Component.month, from: date)
        
        acceptedShifts.forEach { (shift) in
            let month = calNow.component(Calendar.Component.month, from: shift.startDate)
            if( month == calNowMonth){
                currentShifts.append(shift)
                self.monthTotalPay = self.monthTotalPay + shift.basePay + shift.OBmoney + shift.OBnattMoney
                self.monthTotalHours =  Double(self.monthTotalHours) + shift.duration
                self.monthTotalNetto = self.monthTotalNetto + shift.netto
                self.monthTotalBrutto = self.monthTotalBrutto + shift.brutto
            }
        }
        _ = acceptedShifts.sorted { (a, b) -> Bool in
            return a.startDate < b.startDate
        }
        totalLabel.text = String(self.monthTotalBrutto) + " sek"
        tableView.reloadData()
    }
    
    @IBAction func onPreviewsMonthClicked(_ sender: UIButton) {
        self.df.dateFormat = "MMMM"
       
        now = Calendar.current.date(byAdding: .month, value: -1, to: now)!
        df.locale = Locale(identifier: "sv")
        currentMonthLabel.text = df.string(from: now)
        setUpCurrentShifts(date: now)
        
        
    }
    @IBAction func onNextMonthClicked(_ sender: UIButton) {
        df.dateFormat = "MMMM yyyy"
     
        now = Calendar.current.date(byAdding: .month, value: +1, to: now)!
        df.locale = Locale(identifier: "sv")
        currentMonthLabel.text = df.string(from: now)
        setUpCurrentShifts(date: now)
        
    }
    
    
}
