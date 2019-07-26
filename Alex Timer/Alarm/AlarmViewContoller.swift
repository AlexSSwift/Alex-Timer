//
//  AlarmViewContoller.swift
//  Alex Timer
//
//  Created by Austin Zheng on 6/13/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit
import AVFoundation

struct alarm {
    var time: Date
    var reset: [Bool]
    var label: String
    
}

class AlarmViewContoller: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var alarmTableView: UITableView!
    var timer = Timer()
    
   
    
    
    // Alarm Data and Functions
    var alarms: [alarm] = []
    //var alarmDict: [[String:String]] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        alarmTimer()
    }
    
    func rightNow() -> Date {
        let calendar = Calendar.current
        var todaysDate = Date()
        let dateReduced = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: todaysDate)
        todaysDate = calendar.date(from: dateReduced)!
        return todaysDate
    }
    
    func alarmTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AlarmViewContoller.action), userInfo: nil, repeats: true)
        
    }
    
    @objc func action() {
        let now = rightNow()
        for alarm in alarms {
            if alarm.time == now {
                AudioServicesPlayAlertSound(SystemSoundID(1304))
            }
            
        }
    }
    
    func addAlarm(date: Date, reset: [Bool], label: String) {
 
        alarms.append(alarm(time: date, reset: reset, label: label))
        alarmTableView.reloadData()
    }
    
    func parseAlarms(alarmArray: [alarm]) -> [[String:String]] {
        var returnDictArray: [[String:String]] = []
        var dict: [String:String] = [:]
        
        for alarm in alarmArray {
            dict["time"] = dateToString(date: alarm.time)
            dict["reset"] = "\(parseRepeats(repeatArray: alarm.reset))"
            dict["label"] = alarm.label
            returnDictArray.append(dict)
        }
        
        return returnDictArray
    }
    
    func parseRepeats(repeatArray: [Bool]) -> [String] {
        var weekdays: [String] = []
        var weekday = 0
        func switchWeekdays(weekday: Int) -> String {
            switch weekday {
            case 0:
                return "Sun"
            case 1:
                return "Mon"
            case 2:
                return "Tue"
            case 3:
                return "Wed"
            case 4:
                return "Thu"
            case 5:
                return "Fri"
            case 6:
                return "Sat"
            default:
                return ""
            }
        }
        
        for (index, day) in repeatArray.enumerated() {
            if day == true {
                weekday = index
                let switchedDays = switchWeekdays(weekday: weekday)
                weekdays.append(switchedDays)
            }
        }
        return weekdays
    }
    
    
    func dateToString(date: Date) -> String {
        let formater = DateFormatter()
        formater.dateFormat = "h:mm a"
        let formatedDate = formater.string(from: date)
        
        return formatedDate
    }
    
    
    // Table View functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell") as! AlarmTableViewCell
        var alarmDict: [[String:String]] = parseAlarms(alarmArray: alarms)
        let cellTask = alarmDict[indexPath.row]
        
        cell.setAlarmCell(time: cellTask["time"]!, repeatDays: cellTask["reset"]!, label: cellTask["label"]!)
        return cell
    }
    

    @IBAction func addAlarm(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SetAlarmVC")
        let setAlarmVC = viewController as! SetAlarmVC
        
        self.present(setAlarmVC, animated: true, completion: nil)
        
        setAlarmVC.setAlarmClosure = {
            self.addAlarm(date: $0, reset: $1, label: $2)
            
        }
    }
    
    
}
