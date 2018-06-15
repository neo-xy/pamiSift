

import UIKit
import JTAppleCalendar


class ScheduleViewController: UIViewController {
    
    var df: DateFormatter = DateFormatter()
    var gl : CAGradientLayer!
    
    var userShifts: [Shift] = []
    var unavailableDates :[Date] = []
    var shiftsOfMonth: [String:[Shift]]=[:]
    var employeesShifts:[Shift] = []

    
    var pickedDate:Date = Date()
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var collectionView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
//                self.df.dateFormat =  "yyyyMMdd"
//                var shifts = event.element!
//                let key = self.df.string(from:shifts[0].startDate)
//                self.shiftsOfMonth[key] = shifts
                event.element!.forEach({ (shift) in
                    self.employeesShifts.append(shift)
                })
            }
        }

        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.img.frame.size
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.2).cgColor,UIColor.white.cgColor] //Use diffrent colors
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.img.layer.addSublayer(gradientLayer)
        
        collectionView.minimumLineSpacing = 1
        collectionView.minimumInteritemSpacing = 0
        collectionView.scrollToDate(Date())
   
        
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
        df.dateFormat = "MMMM"
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
        cell.dayNr.text = cellState.text
        df.dateFormat = "yyyy MM dd"
        let now = df.string(from: Date())
        let cellDate = df.string(from: cellState.date)
        if(now == cellDate){
            cell.currentDayMark.isHidden = false
        }else{
            cell.currentDayMark.isHidden = true
        }
        
        if(cellState.dateBelongsTo == .thisMonth){
            cell.dayNr.textColor = UIColor(named: "primaryDark")
        }else{
            cell.dayNr.textColor = UIColor.lightGray
        }
        cell.workDayMark.isHidden = true
        userShifts.forEach { (shift) in
            if(areDatesOfTheSameDay(dateOne: cellState.date, dateTwo: shift.startDate)){
                cell.workDayMark.isHidden = false
                return
            }
        }
        cell.notAvailableDay.isHidden = true
        unavailableDates.forEach { (date) in
            if(areDatesOfTheSameDay(dateOne: date, dateTwo: cellState.date)){
                cell.notAvailableDay.isHidden = false
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
        df.dateFormat = "MM dd"
        print(df.string(from: date))
        pickedDate = cellState.date
        performSegue(withIdentifier: "toWeek", sender: self)
    }
    
    func areDatesOfTheSameDay(dateOne:Date, dateTwo:Date) -> Bool {
        if(Calendar.current.compare(dateOne, to: dateTwo, toGranularity: Calendar.Component.day) == .orderedSame){
            return true
        }else{
            return false
        }
    }
}
