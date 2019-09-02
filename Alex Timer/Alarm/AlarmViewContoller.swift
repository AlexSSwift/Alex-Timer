//
//  AlarmViewContoller.swift
//  Alex Timer
//
//  Created by Austin Zheng on 6/13/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

struct Alarm {
    var time: Date
    var resetDays: [Bool]
    var label: String
    var active: Bool
    let identifier: String
}

class AlarmViewContoller: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var alarmTableView: UITableView!
    var alarms: [Alarm] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        retrieveDefaultAlarms()
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        currentPendingNotifications()
        //tempFunction()
    }
    
    func tempFunction() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func currentPendingNotifications(){
        let noticifationCenter = UNUserNotificationCenter.current()
        noticifationCenter.getPendingNotificationRequests(completionHandler: {requests -> () in
            print("this is the number of notifications: \(requests.count)")
            for request in requests {
                print(request.identifier)
            }
        })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
   
    func activateAlarm(alarms: [Alarm]) {
        
        for alarm in alarms {
            if alarm.active == true {
                let content = UNMutableNotificationContent()
                content.title = "Now"
                content.body = alarm.label
                let calendar = Calendar.current
                var resetStatus: Bool = false
                for day in alarm.resetDays {
                    if day == true {
                        resetStatus = true
                    }
                }
                
                if resetStatus == true {
                    for (index, day) in alarm.resetDays.enumerated() {
                        var componentsFromDate = calendar.dateComponents([.hour, .minute], from: alarm.time)
                        if day == true {
                            componentsFromDate.weekday = index + 1
                            alarmTrigger(identifier: alarm.identifier, content: content, dateComponents: componentsFromDate, reset: resetStatus)
                        }
                    }
                } else if resetStatus == false {
                    let componentsFromDate = calendar.dateComponents([.day, .hour, .minute], from: alarm.time)
                    alarmTrigger(identifier: alarm.identifier, content: content, dateComponents: componentsFromDate, reset: resetStatus)
                }
            }
        }
    }
    
    func alarmTrigger(identifier: String, content: UNMutableNotificationContent, dateComponents: DateComponents, reset: Bool) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in

            if error != nil {
                print("There was an error getting authorization")
            }
        }
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: reset)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                print("error: could not add alarm trigger")
            }
        }
    }
    
    func cancelAlarm(whichAlarm: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarms[whichAlarm].identifier])
        alarms[whichAlarm].active = false
    }
    
    func addAlarm(date: Date, resetDays: [Bool], label: String, active: Bool, identifier: String) {
        alarms.append(Alarm(time: date, resetDays: resetDays, label: label, active: active, identifier: identifier))
        alarmHandler.alarmsForDefault = alarms
        activateAlarm(alarms: alarms)
        alarmTableView.reloadData()
        currentPendingNotifications()
    }
    
    func parseAlarms(alarmArray: [Alarm]) -> [[String:String]] {
        var returnDictArray: [[String:String]] = []
        var dict: [String:String] = [:]
        
        for alarm in alarmArray {
            dict["time"] = dateToString(date: alarm.time)
            dict["reset"] = "\(parseRepeats(repeatArray: alarm.resetDays))"
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
    
    func repeatToDateComponent(repeatArray: [Bool]) -> [DateComponents] {
        let calendar = Calendar.current
        var repeatDays: [DateComponents] = []
        for day in repeatArray {
            if day == true {
                let day = DateComponents(calendar: calendar, day: repeatArray.count)
                repeatDays.append(day)
            }
        }
        return repeatDays
    }
    
    func dateToString(date: Date) -> String {
        let formater = DateFormatter()
        formater.dateFormat = "h:mm a"
        let formatedDate = formater.string(from: date)
        
        return formatedDate
    }
   
    func retrieveDefaultAlarms() {
        guard let defaultAlarms = UserDefaults.standard.array(forKey: "alarms") as! [[String:Any]]? else {
            return
        }

        for defaultAlarm in defaultAlarms {
            addAlarm(date: defaultAlarm["time"] as! Date, resetDays: defaultAlarm["reset"] as! [Bool], label: defaultAlarm["label"] as! String, active: defaultAlarm["active"] as! Bool, identifier: defaultAlarm["identifier"] as! String)
        }
        alarmTableView.reloadData()
    }
  
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let thisAlarm = indexPath.row
            cancelAlarm(whichAlarm: thisAlarm)
            alarms.remove(at: indexPath.row)
            alarmHandler.alarmsForDefault.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.endUpdates()
        }
    }
    
    @IBAction func addAlarm(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SetAlarmVC")
        let setAlarmVC = viewController as! SetAlarmVC
        
        self.present(setAlarmVC, animated: true, completion: nil)
        
        setAlarmVC.setAlarmClosure = {
            self.addAlarm(date: $0, resetDays: $1, label: $2, active: $3, identifier: $4)
            
        }
    }
    
    
}
