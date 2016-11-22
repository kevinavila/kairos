//
//  DayViewController.swift
//  Kairos
//
//  Created by Kevin Avila on 10/14/16.
//  Copyright © 2016 BDP. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class DayViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    // Set when user clicks on a date in the month view
    var date:Date? = nil
    
    // Firebase variables
    var user:FIRUser!
    var storageRef:FIRStorageReference!
    var databaseRef:FIRDatabaseReference!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dayViewDateText: UILabel!
    var keyboardIsVisible: Bool! = false
    var inViewMode: Bool! = true
    var currentImageView: Int! = 0
    
    @IBOutlet var images: [UIButton]!
    
    
    // Button image views
    @IBOutlet weak var imageView1: UIButton!
    @IBOutlet weak var imageView2: UIButton!
    @IBOutlet weak var imageView3: UIButton!
    @IBOutlet weak var imageBin: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var editSaveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Firebase storage reference
        let storage = FIRStorage.storage()
        storageRef = storage.reference(forURL: "gs://kairos-7a0bc.appspot.com")
        let database = FIRDatabase.database()
        databaseRef = database.reference()
        
        user = FIRAuth.auth()?.currentUser
        
        textView.delegate = self
        scrollView.delegate = self
        
        // Notifications for when keyboard appears or disappears
        NotificationCenter.default.addObserver(self, selector: #selector(DayViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DayViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Populate day
        // Should you cache?
        if (date == nil) { // App was just opened. Go to current day.
            date = Date()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let selectedDateString = dateFormatter.string(from: date!)
        dayViewDateText.text = selectedDateString
        print(selectedDateString)
        retrieveImages(dateString: selectedDateString)
        
        
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
        
        // Default to VIEW mode
        textView.isEditable = false
        audioButton.isEnabled = false
        self.imageView1.isEnabled = false
        self.imageView2.isEnabled = false
        self.imageView3.isEnabled = false
        self.imageBin.isEnabled = false
        
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
    
    @IBAction func editSaveToggle(_ sender: AnyObject) {
        if (inViewMode == true) { // switch to edit mode
            textView.isEditable = true
            audioButton.isEnabled = true
            self.imageView1.isEnabled = true
            self.imageView2.isEnabled = true
            self.imageView3.isEnabled = true
            self.imageBin.isEnabled = true
            
            editSaveButton.title = "Save"
            inViewMode = false
        } else { // save and switch to view mode
            textView.isEditable = false
            audioButton.isEnabled = false
            self.imageView1.isEnabled = false
            self.imageView2.isEnabled = false
            self.imageView3.isEnabled = false
            self.imageBin.isEnabled = false
            
            saveImages()
            saveText()
            
            editSaveButton.title = "Edit"
            inViewMode = true
        }
        
    }
    
    // Database functions
    
    func retrieveImages(dateString: String) {
        // NOTE: Switch to FirebaseUI for downloading images from storage
        var counter:Int! = 0
        for imageView in images {
            let imageRef = storageRef.child(user.uid+"/"+dateString+"/images/image_\(counter!).jpg")
                
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imageRef.data(withMaxSize: 4 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    print("Unable to download image.")
                } else {
                    if (data != nil) {
                        imageView.setImage(UIImage(data: data!), for: .normal)
                    }
                }
            }
            counter = counter + 1
        }
    }
    
    func saveImages() {
        if (user != nil) {
            let uploadMetadata = FIRStorageMetadata()
            uploadMetadata.contentType = "image/jpeg"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            let dateString = dateFormatter.string(from: date!)
            
            // iterate through images and upload: CURRENTLY ONLY WORKS FOR IV1, IV2, IV3
            var counter:Int! = 0
            for imageView in images {
                if (imageView.currentImage != nil) {
                    let imageData = UIImageJPEGRepresentation(imageView.currentImage!, 0.8)
                    let imageRef = storageRef.child(user.uid+"/"+dateString+"/images/image_\(counter!).jpg")
                    
                    imageRef.put(imageData!, metadata: uploadMetadata, completion: { (metadata, error) -> Void in
                            if (error != nil) {
                                print("Error uploading image: \(error?.localizedDescription)")
                            } else {
                                print("Successfully uploaded image")
                            }
                        })
                    
                }
                counter = counter + 1
            }
        }
    }
    
    func saveText() {
        if (user != nil) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            let dateString = dateFormatter.string(from: date!)
            
            databaseRef.child(user.uid+"/"+dateString+"/text").setValue(self.textView.text!)
            print("Saved text")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
