//
//  AlarmTableViewCell.swift
//  Alex Timer
//
//  Created by Austin Zheng on 6/20/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit

protocol AlarmSwitchDelegate {
    func alarmSwitch(on: Bool, whichCell: Int)
}

class AlarmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmName: UILabel!
    @IBOutlet weak var repeatWhenLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    var alarmSwitchDelegate: AlarmSwitchDelegate!
    
    @IBAction func alarmSwitch(_ sender: UISwitch) {
       alarmSwitchDelegate.alarmSwitch(on: self.alarmSwitch.isOn, whichCell: whichCell) 
    }
    
    var whichCell: Int = -1
    
    func setAlarmCell(time: String, repeatDays: String, label: String) {
   
        timeLabel.text = time
       // repeatWhenLabel.text = repeatDays
        alarmName.text = label + repeatDays
    }
    
    func thisCell(index:Int) {
        whichCell = index
    }
    
}
