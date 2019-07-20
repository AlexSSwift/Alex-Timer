//
//  AlarmViewContoller.swift
//  Alex Timer
//
//  Created by Austin Zheng on 6/13/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit

struct alarm {
    var time: String
    var reset: [Bool]
    var label: String
    
}

class AlarmViewContoller: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var alarmTableView: UITableView!
    var timer = Timer()
    let calendar = Calendar.current
    let rightNow = Date()
    
    
    // Alarm Data and Functions
    var alarms: [alarm] = []
    var alarmDict: [[String:String]] = []
    
    func alarmTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AlarmViewContoller.action), userInfo: nil, repeats: true)
        
    }
    
    @objc func action() {
        
    }
    
    func addAlarm(date: Date, reset: [Bool], label: String) {
        let formater = DateFormatter()
        formater.dateFormat = "h:mm a"
        let formatedDate = formater.string(from: date)
        
        alarms.append(alarm(time: formatedDate, reset: reset, label: label))
        alarmTableView.reloadData()
    }
    
    func parseAlarms(alarmArray: [alarm]) -> [[String:String]] {
        var returnDictArray: [[String:String]] = []
        var dict: [String:String] = [:]
        
        for alarm in alarmArray {
            dict["time"] = "\(alarm.time)"
            dict["reset"] = "\(alarm.reset)"
            dict["label"] = "\(alarm.label)"
            returnDictArray.append(dict)
        }
        
        return returnDictArray
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        
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
