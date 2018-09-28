

import UIKit
import JTAppleCalendar


class ScheduleViewController: UIViewController {
    var departments:[String] = []
        var shiftsOfDay:[Shift] = []
    
    var section:[String : [Shift]] = [:]
    
    
    var pickedDate:Date = Date()

    
    var df: DateFormatter = DateFormatter()
    var gl : CAGradientLayer!
    
    var userShifts: [Shift] = []
    var unavailableDates :[UnavailableDate] = []
    var shiftsOfMonth: [String:[Shift]]=[:]
    var employeesShifts:[Shift] = []
    
    @IBOutlet weak var msgTextField: UITextField!
    @IBOutlet weak var availableSwitch: UISwitch!
    
    @IBAction func availableChanged(_ sender: Any) {
        var isAvailable =  true
        unavailableDates.forEach { (ud) in
            if(areDatesOfTheSameDay(dateOne: ud.date, dateTwo: pickedDate)){
                print("has smae day")
                print(ud.id)
                 FirebaseController.removedUnavailable(id: ud.id)
                isAvailable = false
                return
            }
        }
        if(isAvailable == true){
            var ud = UnavailableDate()
            ud.date =  pickedDate
            ud.employeeId = FirebaseController.user.employeeId
            ud.message = self.msgTextField.text!
            ud.markDate =  Date()
        
            
            FirebaseController.addUnavailableDate(ud: ud)
        }
       
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
  
    @IBOutlet weak var collectionView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidload")
        
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.minimumLineSpacing = 0
        collectionView.minimumInteritemSpacing = 0
        collectionView.scrollToDate(pickedDate)
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        _ = FirebaseController.getUserShifts().subscribe { (event) in
            self.userShifts = []
            self.userShifts = event.element!
            let lastMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -1, to: Date())
           self.userShifts = self.userShifts.filter({ (shift) -> Bool in
                return shift.startDate > lastMonthDate!
            })
        }
     
        employeesShifts = []
    
        FirebaseController.getEmployeesShiftsOfMonth().subscribe { (event) in
            self.employeesShifts.removeAll()
            print("gg " + String(event.element?.count as! Int))
            print("eee" + String(self.employeesShifts.count))
                event.element!.forEach({ (shift) in
                    self.employeesShifts.append(shift)
                })
            self.tableView.reloadData()
        }
        
        shiftsOfDay = []
        departments = []
        section.removeAll()
        
        section.keys.forEach { (section) in
            departments.append(section)
        }
        
        departments.sort { (a, b) -> Bool in
            return a < b
        }

        var index = 0;
       _ = FirebaseController.getUnavailableDates().subscribe { (event) in
        
            self.unavailableDates = []
            self.unavailableDates = event.element!
            self.unavailableDates = self.unavailableDates.filter({ (ud) -> Bool in
                return ud.date > Date()
            })
    
        if(index > 0){
             self.collectionView.reloadData()
        }
        index += 1
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
    }
    
    func setUpCalendarView(dateSegment:DateSegmentInfo){
        guard let date =  dateSegment.monthDates.first?.date else {return}
        df.dateFormat = "MMMM yyyy"
        df.locale = Locale(identifier: "sv")
        monthLabel.text = df.string(from: date)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toWeek"){
            let weekController = segue.destination as! WeekViewController
            weekController.pickedDate = pickedDate
            
            weekController.employeesShifts = employeesShifts
        }
    }
}

extension ScheduleViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
    
        df.dateFormat = "yyyy MM dd"
        let start = df.date(from: "2018 01 01")!
        let end = df.date(from: "2018 12 30")!
        let cal = Calendar.init(identifier: Calendar.Identifier.gregorian)
    
        
        let params = ConfigurationParameters(startDate: start, endDate: end, numberOfRows: 6, calendar: cal, generateInDates: InDateCellGeneration.forAllMonths, generateOutDates: OutDateCellGeneration.tillEndOfGrid, firstDayOfWeek: DaysOfWeek.monday, hasStrictBoundaries: false)
        
//        let params = ConfigurationParameters.init(startDate: start, endDate: end)
            print("config cal")
        return params
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = collectionView.dequeueReusableJTAppleCell(withReuseIdentifier: "cellS", for: indexPath) as! DayCollectionViewCell
      
        cell.dayNr.text = cellState.text
        df.dateFormat = "yyyy MM dd"
        let now = df.string(from: Date())
        let cellDate = df.string(from: cellState.date)


        if(cellState.dateBelongsTo == .thisMonth){
            cell.dayNr.textColor = UIColor.white
        }else{
            cell.dayNr.textColor = UIColor.lightGray
        }
        
        if(cellState.isSelected){
            cell.selectedDate.isHidden = false
            cell.dayNr.textColor = UIColor(named: "pamiOrange")
        }else{
            cell.selectedDate.isHidden = true
        }
        
        if(now == cellDate){
            cell.currentDayMark.isHidden = false
            cell.currentDayMark.layer.borderColor = UIColor.white.cgColor
            cell.currentDayMark.layer.borderWidth = 2
            cell.dayNr.textColor = UIColor.white
        }else{
            cell.currentDayMark.isHidden = true
        }
        
        cell.workDayMark.isHidden = true
        
        userShifts.forEach { (shift) in
        
            if(areDatesOfTheSameDay(dateOne: cellState.date, dateTwo: shift.startDate)){
                cell.workDayMark.isHidden = false
                cell.workDayMark.layer.borderWidth = 1
                cell.workDayMark.layer.borderColor = UIColor.white.cgColor
                return
            }
        }
        
        cell.notAvailableDay.isHidden = true
        unavailableDates.forEach { (ud) in
            if(areDatesOfTheSameDay(dateOne: ud.date, dateTwo: cellState.date)){
                cell.notAvailableDay.isHidden = false
                cell.notAvailableDay.layer.borderColor = UIColor.white.cgColor
                cell.notAvailableDay.layer.borderWidth = 1
                return
            }
        }
        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header = collectionView.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "headerS", for: indexPath) as! headerCollectionReusableView
        return header
    }
    
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpCalendarView(dateSegment: visibleDates)
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
          guard let validCell = cell as? DayCollectionViewCell else{return}
        
        df.dateFormat = "MM dd"
        pickedDate = cellState.date
        validCell.selectedDate.isHidden = false
        validCell.dayNr.textColor = UIColor(named: "pamiOrange")
//        performSegue(withIdentifier: "toWeek", sender: self)
        
        validCell.selectedDate.layer.masksToBounds = false
        validCell.selectedDate.layer.shadowColor = UIColor(named: "pamiShadow")?.cgColor
        validCell.selectedDate.layer.shadowOpacity = 1
        validCell.selectedDate.layer.shadowOffset = CGSize(width: 0, height: 4)
        validCell.selectedDate.layer.shadowRadius = 3
        
        validCell.selectedDate.layer.shouldRasterize = true
        validCell.selectedDate.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        
        availableSwitch.isOn = true
        self.msgTextField.isEnabled = true
        self.msgTextField.text = ""
        unavailableDates.forEach { (ud) in
            if(areDatesOfTheSameDay(dateOne: ud.date, dateTwo: cellState.date)){
                self.availableSwitch.isOn = false
                self.msgTextField.text = ud.message
                self.msgTextField.isEnabled = false
                return
            }
        }
        
        shiftsOfDay = []
        section.removeAll()
        departments = []
       
        employeesShifts.forEach { (shift) in
            if(areDatesOfTheSameDay(dateOne: cellState.date, dateTwo: shift.startDate)){
                shiftsOfDay.append(shift)
                if(section[shift.department.id] == nil){
                    section[shift.department.id] = []
                }
                
                section[shift.department.id]?.append(shift)
            }
        }
        
        section.keys.forEach { (section) in
            departments.append(section)
        }
        
        departments.sort { (a, b) -> Bool in
            return a < b
        }
        
        validCell.selectedDate.bounce()
        tableView.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
          guard let validCell = cell as? DayCollectionViewCell else{return}
        validCell.selectedDate.isHidden = true
        validCell.dayNr.textColor = UIColor.white
    }
    
    func areDatesOfTheSameDay(dateOne:Date, dateTwo:Date) -> Bool {
        if(Calendar.current.compare(dateOne, to: dateTwo, toGranularity: Calendar.Component.day) == .orderedSame){
            return true
        }else{
            return false
        }
    }
}

extension ScheduleViewController:  UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let depName:String = departments[section]

        return  (self.section[depName]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! weekTableViewCell
        
        let depName = departments[indexPath.section]
        
        let shift :Shift = section[depName]![indexPath.row]
        cell.name.text =  shift.firstName + " " + shift.lastName
        cell.department.text =  shift.department.id
        
        if(shift.employeeId == FirebaseController.user.employeeId){
            cell.backgroundColor = UIColor(named: "pamiGreen")
            cell.name.textColor = UIColor.white
            cell.time.textColor = UIColor.white
            cell.department.textColor = UIColor.white
        }else{
            cell.backgroundColor = UIColor.white
            cell.name.textColor = UIColor(named: "mainGray")
            cell.time.textColor = UIColor(named: "mainGray")
            cell.department.textColor = UIColor(named: "mainGray")
        }
        
        df.dateFormat = "HH:mm"
        cell.time.text =  df.string(from: shift.startDate) + "-" + df.string(from: shift.endDate)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.departments[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return departments.count
    }
}

extension UIView{
    func bounce(){
        
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
    }
}
