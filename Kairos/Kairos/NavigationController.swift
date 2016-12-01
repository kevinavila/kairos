//
//  NavigationController.swift
//  Kairos
//
//  Created by Kevin Avila on 10/14/16.
//  Copyright © 2016 BDP. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor.black
        self.navigationBar.tintColor = UIColor(colorWithHexValue: 0x008080)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //self.navigationBar.setBottomBorderColor(color: UIColor(colorWithHexValue: 0x008080), height: 1)
    }
}

extension UINavigationBar {
    
    func setBottomBorderColor(color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
    }
}
