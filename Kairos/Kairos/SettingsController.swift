//
//  SettingsController.swift
//  Kairos
//
//  Created by Kevin Avila on 11/25/16.
//  Copyright © 2016 BDP. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SettingsController: UIViewController {
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var enableRemindersButton: UIButton!
    @IBOutlet weak var noRemindersButton: UIButton!
    var timeForReminders: Date? = nil
    var remindersEnabled: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableRemindersButton.isHidden = true
        datePicker.datePickerMode = UIDatePickerMode.time
    }
    
    @IBAction func datePickerAction(_ sender: AnyObject) {
        timeForReminders = datePicker.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        let timeAsString = dateFormatter.string(from: timeForReminders!)
        print("Time picked: \(timeAsString)")
    }
    
    @IBAction func noRemindersButtonTapped(_ sender: AnyObject) {
        datePicker.isHidden = true
        enableRemindersButton.isHidden = false
        noRemindersButton.isHidden = true
    }
    
    @IBAction func enableRemindersButtonTapped(_ sender: AnyObject) {
        datePicker.isHidden = false
        noRemindersButton.isHidden = false
        enableRemindersButton.isHidden = true
    }
    
    
}

