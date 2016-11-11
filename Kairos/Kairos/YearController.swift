//
//  YearController.swift
//  Kairos
//
//  Created by Kevin Avila on 10/18/16.
//  Copyright © 2016 BDP. All rights reserved.
//

import UIKit

class YearController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var monthClicked:Date!
    
    // Date information
    var year = Calendar.current.component(Calendar.Component.year, from: Date())
    var month = Calendar.current.component(Calendar.Component.month, from: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.year
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "yearCell", for: indexPath) as! YearCell
        
        let yearText = self.year - indexPath.row
        cell.yearLabel.text = String(yearText)
        
        // Highlight current month of current year: PARTIALLY WORKS
        if (yearText == self.year) {
            cell.monthButtons[self.month-1].titleLabel?.textColor = UIColor(colorWithHexValue: 0x008080)
            
            // make future months unclickable
            
        }

        return cell
    }
    
    @IBAction func monthTapped(_ sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! YearCell
        let yearTapped = self.year - (tableView.indexPath(for: cell)?.row)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        switch sender.tag {
            case 1: // Jan
                monthClicked = dateFormatter.date(from: "\(yearTapped)-01-01")
            case 2: // Feb
                monthClicked = dateFormatter.date(from: "\(yearTapped)-02-01")
            case 3: // Mar
                monthClicked = dateFormatter.date(from: "\(yearTapped)-03-01")
            case 4: // Apr
                monthClicked = dateFormatter.date(from: "\(yearTapped)-04-01")
            case 5: // May
                monthClicked = dateFormatter.date(from: "\(yearTapped)-05-01")
            case 6: // Jun
                monthClicked = dateFormatter.date(from: "\(yearTapped)-06-01")
            case 7: // Jul
                monthClicked = dateFormatter.date(from: "\(yearTapped)-07-01")
            case 8: // Aug
                monthClicked = dateFormatter.date(from: "\(yearTapped)-08-01")
            case 9: // Sep
                monthClicked = dateFormatter.date(from: "\(yearTapped)-09-01")
            case 10: // Oct
                monthClicked = dateFormatter.date(from: "\(yearTapped)-10-01")
            case 11: // Nov
                monthClicked = dateFormatter.date(from: "\(yearTapped)-11-01")
            case 12: // Dec
                monthClicked = dateFormatter.date(from: "\(yearTapped)-12-01")
            default:
                break
        }
        self.performSegue(withIdentifier: "yearToMonth", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "yearToMonth") {
            // Get the destination view controller
            let monthVC:MonthController = segue.destination as! MonthController
            monthVC.scrollToDate = monthClicked
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
