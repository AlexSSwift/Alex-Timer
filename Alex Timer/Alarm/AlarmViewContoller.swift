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

class AlarmViewContoller: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate, AlarmSwitchDelegate {
  
    @IBOutlet weak var editButtonProperties: UIButton!
    @IBOutlet weak var alarmTableView: UITableView!
    enum edit {case edit, done}
    var editButtonStatus: edit = edit.edit
    var alarms: [Alarm] = []

   
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        deactivateAllAlarms()
        retrieveDefaultAlarms()
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        currentPendingNotifications()
     // deactivateAllAlarms()
    }
    
    func deactivateAllAlarms() {
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
   
    func activateAlarms(alarms: [Alarm]) {
        for alarm in alarms {
            activateAlarm(alarm: alarm)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "reset" {
            
        } else {
            
        }
        
        completionHandler()
    }
    
    func activateAlarm(alarm: Alarm) {
        if alarm.active == true {
            
            let deactivateAlarm = UNNotificationAction(identifier: "deactivate", title: "OK", options: UNNotificationActionOptions.foreground)
            let resetAlarm = UNNotificationAction(identifier: "reset", title: "Reset Alarm", options: UNNotificationActionOptions.foreground)
            
            let category = UNNotificationCategory(identifier: "myCategory", actions: [resetAlarm, deactivateAlarm], intentIdentifiers: [], options: [])
            UNUserNotificationCenter.current().setNotificationCategories([category])
            
            let content = UNMutableNotificationContent()
            content.title = "Now"
            content.body = alarm.label
            content.categoryIdentifier = "myCategory"
            content.sound = UNNotificationSound.default
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
    
    func alarmSwitch(on: Bool, whichCell: Int) {
        if on != true {
            cancelAlarm(whichAlarm: whichCell)
        }
        if on == true {
            alarms[whichCell].active = true
            activateAlarm(alarm: alarms[whichCell])
        }
    }
    
    func cancelAlarm(whichAlarm: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarms[whichAlarm].identifier])
        alarms[whichAlarm].active = false
    }
    
    func addAlarms(date: Date, resetDays: [Bool], label: String, active: Bool, identifier: String) {
        
        alarms.append(Alarm(time: date, resetDays: resetDays, label: label, active: active, identifier: identifier))
        alarmHandler.alarmsForDefault = alarms
        activateAlarms(alarms: alarms)
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
    
    func parseRepeats(repeatArray: [Bool]) -> String {
        var weekdays: [String] = []
        var weekday: Int = 0
        var repeatDays: String = ""
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
        for (index, day) in weekdays.enumerated(){
            if index > 0 {
                 repeatDays += ", " + day
            } else {
                repeatDays += day
            }
        }
        
        return repeatDays
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
            addAlarms(date: defaultAlarm["time"] as! Date, resetDays: defaultAlarm["reset"] as! [Bool], label: defaultAlarm["label"] as! String, active: defaultAlarm["active"] as! Bool, identifier: defaultAlarm["identifier"] as! String)
        }
        alarmTableView.reloadData()
    }
    
    func editAlarm(whichAlarm: Int, date: Date, resetDays: [Bool], label: String) {
        cancelAlarm(whichAlarm: whichAlarm)
        
        alarms[whichAlarm].time = date
        alarms[whichAlarm].resetDays = resetDays
        alarms[whichAlarm].label = label
        alarms[whichAlarm].active = true
        
        activateAlarm(alarm: alarms[whichAlarm])
        alarmTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell") as! AlarmTableViewCell
        var alarmDict: [[String:String]] = parseAlarms(alarmArray: alarms)
        let cellTask = alarmDict[indexPath.row]
        cell.thisCell(index: indexPath.row)
        cell.setAlarmCell(time: cellTask["time"]!, repeatDays: cellTask["reset"]!, label: cellTask["label"]!)
        cell.alarmSwitchDelegate = self
        
        if alarms[indexPath.row].active == false {
            cell.alarmSwitch.isOn = false
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if editButtonStatus == edit.done {
            let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
            let setAlarmVC = storyboard.instantiateViewController(withIdentifier: "SetAlarmVC") as! SetAlarmVC
            let currentAlarm = alarms[indexPath.row]
            
            setAlarmVC.setDate = currentAlarm.time
            setAlarmVC.setReset = currentAlarm.resetDays
            setAlarmVC.setLabel = currentAlarm.label
            setAlarmVC.editingAlarm = true
            
            self.present(setAlarmVC, animated: true, completion: nil)
            
            setAlarmVC.editAlarmClosure = {
                self.editAlarm(whichAlarm: indexPath.row, date: $0, resetDays: $1, label: $2)
            }
            editButtonProperties.setTitle("Edit", for: UIControl.State.normal)
            for (index, _) in alarms.enumerated() {
                let currentCell = IndexPath(row: index, section: 0)
                let cell = alarmTableView.cellForRow(at: currentCell) as! AlarmTableViewCell
                cell.alarmSwitch.isHidden = false
            }
            editButtonStatus = edit.edit
        }
    }
    
    @IBAction func addAlarm(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SetAlarmVC")
        let setAlarmVC = viewController as! SetAlarmVC
        
        self.present(setAlarmVC, animated: true, completion: nil)
        
        setAlarmVC.setAlarmClosure = {
            self.addAlarms(date: $0, resetDays: $1, label: $2, active: $3, identifier: $4)
            
        }
    }
    
    @IBAction func editButton(_ sender: UIButton) {
        if editButtonStatus == edit.edit {
            editButtonProperties.setTitle("Done", for: UIControl.State.normal)
            for (index, _) in alarms.enumerated() {
                let currentCell = IndexPath(row: index, section: 0)
                let cell = alarmTableView.cellForRow(at: currentCell) as! AlarmTableViewCell
                cell.alarmSwitch.isHidden = true
            }
            
            editButtonStatus = edit.done
        } else if editButtonStatus == edit.done {
            editButtonProperties.setTitle("Edit", for: UIControl.State.normal)
            for (index, _) in alarms.enumerated() {
                let currentCell = IndexPath(row: index, section: 0)
                let cell = alarmTableView.cellForRow(at: currentCell) as! AlarmTableViewCell
                cell.alarmSwitch.isHidden = false
            }
            
            editButtonStatus = edit.edit
        }
    }
    
    
    
}
