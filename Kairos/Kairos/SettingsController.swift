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
    var firstName:String?
    
    var databaseRef:FIRDatabaseReference!
    var user:FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let database = FIRDatabase.database()
        databaseRef = database.reference()
        
        user = FIRAuth.auth()?.currentUser
        let fullNameArr = user.displayName?.characters.split{$0 == " "}.map(String.init)
        firstName = fullNameArr?[0]
        
        self.datePicker.datePickerMode = UIDatePickerMode.time
        databaseRef.child(user.uid+"/reminder_time").observeSingleEvent(of: .value, with: { (snapshot) in
            let text = snapshot.value as? String
            if (text != nil) {
                if (text == "REMINDERS_DISABLED") {
                    self.noRemindersButtonTapped(UIDatePicker())
                } else {
                    // Set date picker to date from database
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "hh:mm a"
                    let date = dateFormatter.date(from: text!)
                    self.datePicker.date = date!
                    
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
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        let timeAsString = dateFormatter.string(from: datePicker.date)
        print("Time picked: \(timeAsString)")
        
        databaseRef.child(user.uid+"/reminder_time").setValue(timeAsString)
        
        scheduleReminder()
    }
    
    @IBAction func noRemindersButtonTapped(_ sender: AnyObject) {
        datePicker.isHidden = true
        enableRemindersButton.isHidden = false
        noRemindersButton.isHidden = true
        
        UIApplication.shared.cancelAllLocalNotifications()
        databaseRef.child(user.uid+"/reminder_time").setValue("REMINDERS_DISABLED")
    }
    
    @IBAction func enableRemindersButtonTapped(_ sender: AnyObject) {
        datePicker.isHidden = false
        noRemindersButton.isHidden = false
        enableRemindersButton.isHidden = true
        
        datePickerAction(UIDatePicker())
    }
    
    func scheduleReminder() {
        UIApplication.shared.cancelAllLocalNotifications()
        
        let notification = UILocalNotification()
        notification.alertBody = "Hey \(self.firstName!), time to log for the day!"
        notification.alertAction = "log"
        notification.repeatInterval = NSCalendar.Unit.day
        
//        var dateComponets: DateComponents = NSCalendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year, Calendar.Component.hour, Calendar.Component.minute], from: datePicker.date)
//        dateComponets.second = 0
//        let fixedDate: NSDate! = NSCalendar.current.date(from: dateComponets) as NSDate!
        
        notification.fireDate = datePicker.date
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    
}

