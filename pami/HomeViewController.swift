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

    
    var shifts = [Shift]()
    var upcommingShifts:[Shift] = []
    let now = Date()
    
    @IBOutlet weak var upcommingShiftsTableView: UpcommingShifts!
    var df = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        infoMessageFrame.layer.cornerRadius = 5
        
        upcommingShiftsTableView.delegate = self
        upcommingShiftsTableView.dataSource = self
        
        df.locale = Locale(identifier: "sv")
        
        _ = FirebaseController.getInfoMessage().subscribe { (event) in
            let author = event.element?.author
            let msg = event.element?.message
            let date = event.element?.date
            
            self.df.dateFormat = "dd MMM HH:mm:ss"
            
            self.infoMessageDate.text = self.df.string(from: date!)
            self.infoMessageText.text = msg
            self.infoMessageAuthor.text = author
        }
        
       _ = FirebaseController.getUserShifts().subscribe { (event) in
            self.shifts = event.element!
        
        self.shifts = self.shifts.filter({ (a) -> Bool in
            return a.startDate > self.now
        })
        self.shifts.sort(by: { (a, b) -> Bool in
            return a.startDate < b.startDate
        })
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
        
        
        cel.cardContainer.layer.cornerRadius = 6
        
//        cel.cardContainer.layer.masksToBounds = false
//        cel.cardContainer.layer.shadowColor = UIColor.gray.cgColor
//        cel.cardContainer.layer.shadowOpacity = 1
//        cel.cardContainer.layer.shadowOffset = CGSize(width: -1, height: 1)
//        cel.cardContainer.layer.shadowRadius = 6
//        
//        cel.cardContainer.layer.shadowPath = UIBezierPath(rect: cel.cardContainer.self.bounds).cgPath
//        cel.cardContainer.layer.shouldRasterize = true
//        cel.cardContainer.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        
        cel.extraInfoMsg.text = shifts[indexPath.row].message
        cel.extraInfoMsg.textColor = hexStringToUIColor(hex: shifts[indexPath.row].department.color).darker(by: 35.0)
        df.dateFormat = "MMM"
        cel.dateMonthLabel.text = df.string(from: shifts[indexPath.row].startDate)
        cel.dateMonthLabel.textColor = hexStringToUIColor(hex: shifts[indexPath.row].department.color).darker(by: 35.0)
        df.dateFormat = "dd"
        cel.dateNrLabel.text = df.string(from: shifts[indexPath.row].startDate)
        cel.dateNrLabel.textColor = hexStringToUIColor(hex: shifts[indexPath.row].department.color).darker(by: 35.0)
        cel.departmentLabel.text = shifts[indexPath.row].department.id
        cel.departmentLabel.textColor = hexStringToUIColor(hex: shifts[indexPath.row].department.color).darker(by: 35.0)
        cel.extraInfoLabel.text = "Extra info:"
        cel.extraInfoLabel.textColor = hexStringToUIColor(hex: shifts[indexPath.row].department.color).darker(by: 35.0)
        df.dateFormat = "HH:mm"
        cel.shiftTimeSpanLabel.text = df.string(from: shifts[indexPath.row].startDate) + "-" + df.string(from: shifts[indexPath.row].endDate)
        cel.shiftTimeSpanLabel.textColor = hexStringToUIColor(hex: shifts[indexPath.row].department.color).darker(by: 35.0)
        
        
        cel.cardContainer.layer.backgroundColor = hexStringToUIColor(hex: shifts[indexPath.row].department.color).withAlphaComponent(0.3).cgColor
        
      cel.cardContainer.isOpaque = true
    
        
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

    
}

extension UIColor {
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
