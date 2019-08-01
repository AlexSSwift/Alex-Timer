//
//  AlarmTableViewCell.swift
//  Alex Timer
//
//  Created by Austin Zheng on 6/20/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {

   
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmName: UILabel!
    @IBOutlet weak var repeatWhenLabel: UILabel!
    @IBAction func alarmSwitch(_ sender: UISwitch) {
    }
    
    func setAlarmCell(time: String, repeatDays: String, label: String) {
        timeLabel.text = time
        repeatWhenLabel.text = repeatDays
        alarmName.text = label
    }
 
    
}
