//
//  DayViewController.swift
//  Kairos
//
//  Created by Kevin Avila on 10/14/16.
//  Copyright © 2016 BDP. All rights reserved.
//

import UIKit

class DayViewController: UIViewController {
    
    // Set when user clicks on a date in the month view
    var date:Date? = nil
    
    @IBOutlet weak var dayViewDateText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            let selectedDateString = dateFormatter.string(from: date!)
            dayViewDateText.text = selectedDateString
            print(selectedDateString)
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
