//
//  DayViewController.swift
//  Kairos
//
//  Created by Kevin Avila on 10/14/16.
//  Copyright © 2016 BDP. All rights reserved.
//

import UIKit

class DayViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {
    
    // Set when user clicks on a date in the month view
    var date:Date? = nil
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dayViewDateText: UILabel!
    var keyboardIsVisible: Bool! = false
    
    // Button image views
    @IBOutlet weak var imageView1: UIButton!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageBin: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textView.delegate = self
        scrollView.delegate = self
        
        // Notifications for when keyboard appears or disappears
        NotificationCenter.default.addObserver(self, selector: #selector(DayViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DayViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            let selectedDateString = dateFormatter.string(from: date!)
            dayViewDateText.text = selectedDateString
            print(selectedDateString)
        }
        
        // Change border color of image views
        self.imageView1.layer.borderColor = UIColor(colorWithHexValue: 0x008080).cgColor
        self.imageView2.layer.borderColor = UIColor(colorWithHexValue: 0x008080).cgColor
        self.imageView3.layer.borderColor = UIColor(colorWithHexValue: 0x008080).cgColor
        self.imageBin.layer.borderColor = UIColor(colorWithHexValue: 0x008080).cgColor
        
        self.imageView1.layer.borderWidth = 1.0
        self.imageView2.layer.borderWidth = 1.0
        self.imageView3.layer.borderWidth = 1.0
        self.imageBin.layer.borderWidth = 1.0
    }
    
    // Image view functions
    
    @IBAction func tappedImageView1(_ sender: AnyObject) {
        if (keyboardIsVisible == true) {
            textView.endEditing(true)
        } else {
            print("tapped image view 1")
        }
    }
    
    // Text view functions
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
    }
    
    // Keyboard functions
    
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
        keyboardIsVisible = true
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
        keyboardIsVisible = false
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
//        UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
//            self.bottomConstraint.constant += changeInHeight
//        })
    }
    
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        textView.endEditing(true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
