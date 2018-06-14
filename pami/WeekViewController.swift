

import UIKit
import JTAppleCalendar

class WeekViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var df = DateFormatter()
    
    @IBOutlet weak var weekLabel:UILabel!

    @IBOutlet weak var tableView: UITableView!
    var name:String = "ff"
    var pickedDate:Date = Date()
    var employeesShifts:[Shift] = []
    @IBOutlet var collectionView : JTAppleCalendarView!
    
    var shiftsOfDay:[Shift] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(name)
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.scrollToDate(pickedDate)
        collectionView.selectDates([pickedDate])
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        print(weekOfYear)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.isToolbarHidden = false

        weekLabel.text = "Vecka " + String(weekOfYear)
        collectionView.scrollingMode = .stopAtEachCalendarFrame
        collectionView.minimumLineSpacing = 0
        collectionView.minimumInteritemSpacing = 0
        
        
        shiftsOfDay = []
        employeesShifts.forEach { (shift) in
            if(areDatesOfTheSameDay(dateOne: pickedDate, dateTwo: shift.startDate)){
                shiftsOfDay.append(shift)
            }
        }
        tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(employeesShifts.count)
        return shiftsOfDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! weekTableViewCell
        cell.name.text =  employeesShifts[indexPath.row].firstName + " " + employeesShifts[indexPath.row].lastName
        cell.department.text = employeesShifts[indexPath.row].department.id
        print(employeesShifts[indexPath.row].department.id)

        return cell
    }
    
    func areDatesOfTheSameDay(dateOne:Date, dateTwo:Date) -> Bool {
        if(Calendar.current.compare(dateOne, to: dateTwo, toGranularity: Calendar.Component.day) == .orderedSame){
            return true
        }else{
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("sag")
    }

}

extension WeekViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = collectionView.dequeueReusableJTAppleCell(withReuseIdentifier: "cell", for: indexPath) as! DayCollectionViewCell
        cell.dayNr.text = cellState.text
        df.dateFormat = "MMM"
        df.locale = Locale(identifier: "sv")
        cell.dateLabel.text = df.string(from: cellState.date)
        if(cellState.isSelected){
            cell.backgroundColor = UIColor(named: "lightGray")
        }else{
            cell.layer.backgroundColor = UIColor.white.cgColor
        }
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        df.dateFormat = "yyyy MM dd"
        let start = df.date(from: "2018 01 01")!
        let end = df.date(from: "2018 12 31")!
        
        let params = ConfigurationParameters(startDate: start, endDate: end, numberOfRows: 1, calendar: nil, generateInDates: nil, generateOutDates: nil, firstDayOfWeek: DaysOfWeek.monday, hasStrictBoundaries: false)
        
        return params
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header =  collectionView.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "header", for: indexPath)
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? DayCollectionViewCell else{return}
        validCell.backgroundColor = UIColor(named: "lightGray")
        print("hhh")
        shiftsOfDay = []
        employeesShifts.forEach { (shift) in
            if(areDatesOfTheSameDay(dateOne: cellState.date, dateTwo: shift.startDate)){
                shiftsOfDay.append(shift)
            }
        }
        tableView.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? DayCollectionViewCell else{return}
        validCell.backgroundColor = UIColor.white
    }

    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let calendar = Calendar.current
        
        if(visibleDates.monthDates.count > 1){
            let weekOfYear = calendar.component(.weekOfYear, from: visibleDates.monthDates[1].date)
            weekLabel.text = "Vecka " + String(weekOfYear)
        }else if(visibleDates.outdates.count > 1){
            let weekOfYear = calendar.component(.weekOfYear, from: visibleDates.outdates[1].date)
            weekLabel.text = "Vecka " + String(weekOfYear)
        }else{
            let weekOfYear = calendar.component(.weekOfYear, from: visibleDates.indates[1].date)
            weekLabel.text = "Vecka " + String(weekOfYear)
        }
    
    }
   
}
