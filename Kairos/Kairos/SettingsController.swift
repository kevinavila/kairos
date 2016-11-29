//
//  SettingsController.swift
//  Kairos
//
//  Created by Kevin Avila on 11/25/16.
//  Copyright © 2016 BDP. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SettingsController: UIViewController {
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var enableRemindersButton: UIButton!
    @IBOutlet weak var noRemindersButton: UIButton!
    var timeForReminders: Date? = nil
    
    var databaseRef:FIRDatabaseReference!
    var user:FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let database = FIRDatabase.database()
        databaseRef = database.reference()
        
        user = FIRAuth.auth()?.currentUser
        
        self.datePicker.datePickerMode = UIDatePickerMode.time
        databaseRef.child(user.uid+"/reminder_time").observeSingleEvent(of: .value, with: { (snapshot) in
            let text = snapshot.value as? String
            if (text != nil) {
                if (text == "REMINDERS_DISABLED") {
                    self.noRemindersButtonTapped(UIDatePicker())
                } else {
                    // Set date picker to date from database
                    self.enableRemindersButton.isHidden = true
                }
            } else { // first time opening settings screen
                self.enableRemindersButtonTapped(UIDatePicker())
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func datePickerAction(_ sender: AnyObject) {
        timeForReminders = datePicker.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        let timeAsString = dateFormatter.string(from: timeForReminders!)
        print("Time picked: \(timeAsString)")
        
        databaseRef.child(user.uid+"/reminder_time").setValue(timeAsString)
    }
    
    @IBAction func noRemindersButtonTapped(_ sender: AnyObject) {
        datePicker.isHidden = true
        enableRemindersButton.isHidden = false
        noRemindersButton.isHidden = true
        
        databaseRef.child(user.uid+"/reminder_time").setValue("REMINDERS_DISABLED")
    }
    
    @IBAction func enableRemindersButtonTapped(_ sender: AnyObject) {
        datePicker.isHidden = false
        noRemindersButton.isHidden = false
        enableRemindersButton.isHidden = true
        
        datePickerAction(UIDatePicker())
    }
    
    
}

