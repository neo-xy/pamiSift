

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
    var unavailableDates :[Date] = []
    var shiftsOfMonth: [String:[Shift]]=[:]
    var employeesShifts:[Shift] = []
    
    @IBAction func onUnavailableClick(_ sender: Any) {
    }
    

    @IBAction func onAvailableClick(_ sender: Any) {
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var unavailableBtn: UIButton!
    @IBOutlet weak var availableBtn: UIButton!
    
  
    @IBOutlet weak var collectionView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        availableBtn.layer.borderWidth = 2
//        availableBtn.layer.borderColor = UIColor(named: "pamiGreen")?.cgColor
//        
//        
//        unavailableBtn.layer.borderWidth = 2
//        unavailableBtn.layer.borderColor = UIColor(named: "pamiRed")?.cgColor
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        _ = FirebaseController.getUserShifts().subscribe { (event) in
            self.userShifts = []
            self.userShifts = event.element!
            let lastMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -1, to: Date())
            self.userShifts.filter({ (shift) -> Bool in
                return shift.startDate > lastMonthDate!
            })
            self.collectionView.reloadData()
        }
        _ = FirebaseController.getUnavailableDates().subscribe { (event) in
            self.unavailableDates = []
            self.unavailableDates = event.element!
            self.unavailableDates.filter({ (date) -> Bool in
                return date > Date()
            })
            self.collectionView.reloadData()
        }
        employeesShifts = []
        for i in 0...2{
            let date =  Calendar.current.date(byAdding: Calendar.Component.month, value: i, to: Date())
            var sub = FirebaseController.getEmployeesShiftsOfMonth(date: date!).subscribe { (event) in
       
                event.element!.forEach({ (shift) in
                    self.employeesShifts.append(shift)
                })
            }
        }
        
        collectionView.minimumLineSpacing = 0
        collectionView.minimumInteritemSpacing = 0
        collectionView.scrollToDate(Date())
        
        shiftsOfDay = []
        departments = []
        section.removeAll()
        
        employeesShifts.forEach { (shift) in
            if(areDatesOfTheSameDay(dateOne: pickedDate, dateTwo: shift.startDate)){
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
        tableView.reloadData()
        
        
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
            var weekController = segue.destination as! WeekViewController
            weekController.pickedDate = pickedDate
            
            print("eee \(employeesShifts.count)")
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
        let end = df.date(from: "2018 12 31")!
        
        let params = ConfigurationParameters(startDate: start, endDate: end, numberOfRows: 6, calendar: nil, generateInDates: nil, generateOutDates: nil, firstDayOfWeek: DaysOfWeek.monday, hasStrictBoundaries: false)
        
        return params
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = collectionView.dequeueReusableJTAppleCell(withReuseIdentifier: "cellS", for: indexPath) as! DayCollectionViewCell
        
        if(cell.isSelected){
            cell.selectedDate.isHidden = false
        }else{
            cell.selectedDate.isHidden = true
        }
        cell.dayNr.text = cellState.text
        df.dateFormat = "yyyy MM dd"
        let now = df.string(from: Date())
        let cellDate = df.string(from: cellState.date)
        
        
        if(cellState.dateBelongsTo == .thisMonth){
            cell.dayNr.textColor = UIColor.white
        }else{
            cell.dayNr.textColor = UIColor.lightGray
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
        unavailableDates.forEach { (date) in
            if(areDatesOfTheSameDay(dateOne: date, dateTwo: cellState.date)){
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
        print(df.string(from: date))
        pickedDate = cellState.date
        validCell.selectedDate.isHidden = false
        validCell.dayNr.textColor = UIColor(named: "pamiOrange")
//        performSegue(withIdentifier: "toWeek", sender: self)
        
        
    
        availableBtn.backgroundColor = UIColor(named: "pamiGreen")
        availableBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        unavailableBtn.backgroundColor = UIColor.white
        unavailableBtn.setTitleColor(UIColor(named: "pamiRed"), for: UIControlState.normal)
        unavailableDates.forEach { (date) in
            if(areDatesOfTheSameDay(dateOne: date, dateTwo: cellState.date)){
              
                availableBtn.backgroundColor = UIColor.white
                availableBtn.setTitleColor(UIColor(named: "pamiGreen"), for: UIControlState.normal)
                unavailableBtn.backgroundColor = UIColor(named: "pamiRed")
                unavailableBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
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
        
        var depName:String = departments[section]

        return  (self.section[depName]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! weekTableViewCell
        
        
        var depName = departments[indexPath.section]
        
        var shift :Shift = section[depName]![indexPath.row]
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
        print("name \(self.departments[section])")
        return self.departments[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("sec \(departments.count)")
        return departments.count
    }
    
    
}

