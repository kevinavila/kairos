//
//  MonthController.swift
//  Kairos
//
//  Created by Kevin Avila on 10/18/16.
//  Copyright © 2016 BDP. All rights reserved.
//

import UIKit
import JTAppleCalendar

class MonthController: UIViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    
    @IBOutlet var calendarView: JTAppleCalendarView!
    var selectedDate:Date? = Date()
    var scrollToDate:Date!
    var globalCalendarObject:Calendar = Calendar(identifier: .gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CellView") // Registering your cell is manditory
        calendarView.registerHeaderView(xibFileNames: ["MonthHeader"])
        
        // No spaces between cells
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        
        calendarView.reloadData()
        
        // After reloading. Scroll to your selected date, and setup your calendar
        if (scrollToDate != nil) {
            calendarView.scrollToDate(scrollToDate, triggerScrollToDateDelegate: false, animateScroll: false)
        } else {
            calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: false, animateScroll: false)
        }
    }
    
    // Return parameters to configure the calendar
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "1995 01 01")! // You can use date generated from a formatter
        let endDate = Date()                                // You can also use dates created from this function
        let calendarObject = self.globalCalendarObject
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 5,
                                                 calendar: calendarObject,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }
    
    // Delegate method to display date cells
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let myCustomCell = cell as! CellView
        
        // Setup Cell text
        myCustomCell.dayLabel.text = cellState.text
        
        // Setup text color
        if cellState.dateBelongsTo == .thisMonth {
            myCustomCell.dayLabel.textColor = UIColor(colorWithHexValue: 0xECEAED)
        } else {
            myCustomCell.dayLabel.textColor = UIColor(colorWithHexValue: 0x575757)
            // Make cell unselectable
        }
    }
    
    // Called when cell is selected
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        self.selectedDate = date
        
        if cellState.isSelected {
            self.performSegue(withIdentifier: "goToDay", sender: self)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        //print("Scroll")
    }
    
    // This sets the height of your header
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: 200, height: 150)
    }
    
    // This setups the display of your header
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        let headerCell = (header as? MonthHeader)
        let month = self.globalCalendarObject.component(Calendar.Component.month, from: range.end)
        let year = self.globalCalendarObject.component(Calendar.Component.year, from: range.end)
        let monthNames = DateFormatter().monthSymbols as [String]
        headerCell?.monthLabel.text = monthNames[month-1]
        headerCell?.yearLabel.text = String(year)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDay" {
            
            // Get the destination view controller
            let dayVC:DayViewController = segue.destination as! DayViewController
            dayVC.date = self.selectedDate
        }
        
    }
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
