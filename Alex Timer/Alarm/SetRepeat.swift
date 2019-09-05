//
//  SetRepeat.swift
//  Alex Timer
//
//  Created by Austin Zheng on 7/8/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit

class SetRepeatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SetAlarmResetDelegate {
  
    @IBOutlet weak var repeatTableView: UITableView!
    
    var repeatClosure: (([Bool]) -> Void)!
    let days = ["Every Sunday", "Every Monday", "Every Tuesday", "Every Wednesday", "Every Thursday", "Every Friday", "Every Saturday"]
    var daysChecked = [false, false, false, false, false, false, false]
    let setAlarmVC = SetAlarmVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repeatTableView.delegate = self
        repeatTableView.dataSource = self
       
        setAlarmVC.setAlarmResetDelegate = self
    }
    
    
    func reset(reset: [Bool]) {
        daysChecked = reset
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "defaultCell")
        }
        
        let cellTask = days[indexPath.row]
        cell.textLabel?.text = cellTask
        
        let currentDay = daysChecked[indexPath.row]
        if currentDay == true {
             cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var currentDay = daysChecked[indexPath.row]
        
        if currentDay == false {
            currentDay = true
        } else {
            currentDay = false
        }
        
        daysChecked.remove(at: indexPath.row)
        daysChecked.insert(currentDay, at: indexPath.row)
        repeatTableView.reloadData()
    }
  
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        repeatClosure(daysChecked)
    }

}
