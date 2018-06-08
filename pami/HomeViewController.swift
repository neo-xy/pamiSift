//
//  HomeViewController.swift
//  pami
//
//  Created by Pawel  on 2018-06-06.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var infoMessageAuthor: UILabel!
    @IBOutlet weak var infoMessageFrame: UIView!
    @IBOutlet weak var infoMessageDate: UILabel!
    @IBOutlet weak var infoMessageText: UILabel!
    @IBOutlet weak var shiftMark: UIView!
    
    var shifts = [Shift]()
    
    @IBOutlet weak var upcommingShiftsTableView: UpcommingShifts!
    var df = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoMessageFrame.layer.cornerRadius = 5
        
        
        //        self.upcommingShiftsTableView.register(UpcommmingShiftRowTableViewCell.self, forCellReuseIdentifier: "cell")
        upcommingShiftsTableView.delegate = self
        upcommingShiftsTableView.dataSource = self
        
        df.locale = Locale(identifier: "sv")
        
        FirebaseController.getInfoMessage().subscribe { (event) in
            let author = event.element?.author
            let msg = event.element?.message
            let date = event.element?.date
            
            self.df.dateFormat = "dd MMM HH:mm:ss"
            
            self.infoMessageDate.text = self.df.string(from: date!)
            self.infoMessageText.text = msg
            self.infoMessageAuthor.text = author
        }
        
        FirebaseController.getUserShifts().subscribe { (event) in
            self.shifts =  event.element!
            self.upcommingShiftsTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cel = upcommingShiftsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UpcommmingShiftRowTableViewCell
        
        
        cel.layer.shadowOffset = CGSize(width: 0, height: 0)
        cel.layer.shadowColor = UIColor(named: "primaryColor")?.cgColor
        cel.layer.shadowRadius = 6
        cel.layer.shadowOpacity = 0.5
        cel.layer.masksToBounds = false;
        cel.clipsToBounds = false;
        
        cel.extraInfoMsg.text = shifts[indexPath.row].message
        df.dateFormat = "MMM"
        cel.dateMonthLabel.text = df.string(from: shifts[indexPath.row].startDate)
        df.dateFormat = "dd"
        cel.dateNrLabel.text = df.string(from: shifts[indexPath.row].startDate)
        cel.departmentLabel.text = shifts[indexPath.row].department.id
        cel.extraInfoLabel.text = "Extra info:"
        df.dateFormat = "HH:mm"
        cel.shiftTimeSpanLabel.text = df.string(from: shifts[indexPath.row].startDate) + "-" + df.string(from: shifts[indexPath.row].endDate)
        cel.shiftMark.layer.backgroundColor = hexStringToUIColor(hex: shifts[indexPath.row].department.color).cgColor
    
        
        return cel
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
