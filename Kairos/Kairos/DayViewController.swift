//
//  DayViewController.swift
//  Kairos
//
//  Created by Kevin Avila on 10/14/16.
//  Copyright © 2016 BDP. All rights reserved.
//

import UIKit

class DayViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    // Set when user clicks on a date in the month view
    var date:Date? = nil
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dayViewDateText: UILabel!
    var keyboardIsVisible: Bool! = false
    var currentImageView: Int! = 0
    
    // Button image views
    @IBOutlet weak var imageView1: UIButton!
    @IBOutlet weak var imageView2: UIButton!
    @IBOutlet weak var imageView3: UIButton!
    @IBOutlet weak var imageBin: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var dvSaveButton: UIButton!
    
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
        
        // Change border color of image views and audio button
        self.imageView1.layer.borderColor = UIColor(colorWithHexValue: 0x008080).cgColor
        self.imageView2.layer.borderColor = UIColor(colorWithHexValue: 0x008080).cgColor
        self.imageView3.layer.borderColor = UIColor(colorWithHexValue: 0x008080).cgColor
        self.imageBin.layer.borderColor = UIColor(colorWithHexValue: 0x008080).cgColor
        self.audioButton.layer.borderColor = UIColor(colorWithHexValue: 0x008080).cgColor
        
        self.imageView1.layer.borderWidth = 1.0
        self.imageView2.layer.borderWidth = 1.0
        self.imageView3.layer.borderWidth = 1.0
        self.imageBin.layer.borderWidth = 1.0
        self.audioButton.layer.borderWidth = 1.0
    }
    
    // Image view functions
    
    @IBAction func tappedImageView1(_ sender: AnyObject) {
        currentImageView = 1
        if (keyboardIsVisible == true) {
            dismissKeyboard(self)
        } else {
            print("Tapped image view 1")
            imagePickerHelper()
        }
    }
    
    @IBAction func tappedImageView2(_ sender: AnyObject) {
        currentImageView = 2
        if (keyboardIsVisible == true) {
            dismissKeyboard(self)
        } else {
            print("Tapped image view 2")
            imagePickerHelper()
        }
    }
    
    @IBAction func tappedImageView3(_ sender: AnyObject) {
        currentImageView = 3
        if (keyboardIsVisible == true) {
            dismissKeyboard(self)
        } else {
            print("Tapped image view 3")
            imagePickerHelper()
        }
    }
    
    @IBAction func tappedImageBin(_ sender: AnyObject) {
        currentImageView = 4
        if (keyboardIsVisible == true) {
            dismissKeyboard(self)
        } else {
            print("Tapped image bin")
            imagePickerHelper()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            var imageView: UIButton!
            switch currentImageView {
            case 1:
                imageView = imageView1
            case 2:
                imageView = imageView2
            case 3:
                imageView = imageView3
            case 4:
                imageView = imageBin
            default:
                imageView = UIButton()
                print("No image view selected")
            }
            imageView.contentMode = .scaleAspectFit
            imageView.setImage(pickedImage, for: UIControlState.normal)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerHelper() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            //imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
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
    
    // Save to database
    
    @IBAction func dvSaveButtonClicked(_ sender: AnyObject) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
