//
//  YearController.swift
//  Kairos
//
//  Created by Kevin Avila on 10/18/16.
//  Copyright © 2016 BDP. All rights reserved.
//

import UIKit

class YearController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Date information
    var year = Calendar.current.component(Calendar.Component.year, from: Date())
    var month = Calendar.current.component(Calendar.Component.month, from: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.year
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "yearCell", for: indexPath) as! YearCell
        
        let yearText = self.year - indexPath.row
        cell.yearLabel.text = String(yearText)
        
        // Highlight current month of current year: PARTIALLY WORKS
        if (yearText == self.year) {
            cell.monthButtons[self.month-1].titleLabel?.textColor = UIColor(colorWithHexValue: 0x008080)
        }

        return cell
    }
    
    @IBAction func monthTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "yearToMonth", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
