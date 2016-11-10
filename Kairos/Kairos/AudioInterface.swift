//
//  AudioInterface.swift
//  Kairos
//
//  Created by Kevin Avila on 11/10/16.
//  Copyright © 2016 BDP. All rights reserved.
//

import UIKit

class AudioInterface: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func userClickedCancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userClickedDone(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}
