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
    
    // Image views
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageBin: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textView.delegate = self
        scrollView.delegate = self
        
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
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
    }
    
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        textView.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
