//
//  ViewController.swift
//  Kairos
//
//  Created by Kevin Avila on 10/7/16.
//  Copyright © 2016 BDP. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class LoginController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        facebookLoginButton.readPermissions = ["public_profile", "email"]
        facebookLoginButton.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        self.facebookLoginButton.isHidden = true
        
        if error != nil {
            print(error!.localizedDescription)
            self.facebookLoginButton.isHidden = false
            return
        } else if (result.isCancelled)  { // User canceled login
            self.facebookLoginButton.isHidden = false
        } else { // User successfully logged in
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if (error != nil) {
                    print(error!.localizedDescription)
                }
                print("User logged in with facebook...")
                
                // Initialize navigation controller
                self.performSegue(withIdentifier: "navSegue", sender: self)
            })
        }
        
    }
    
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()!.signOut()
        FBSDKAccessToken.setCurrent(nil)
        print("User logged out of facebook...")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "navSegue" {
            
            // Get the destination view controller
            let navVC:NavigationController = segue.destination as! NavigationController
            let monthVC = self.storyboard?.instantiateViewController(withIdentifier: "monthController")
            let dayVC = self.storyboard?.instantiateViewController(withIdentifier: "dayViewController")
            
            navVC.pushViewController(monthVC!, animated: false)
            navVC.pushViewController(dayVC!, animated: false)
        }
        
    }

}

