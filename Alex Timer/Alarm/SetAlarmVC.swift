//
//  SetAlarmVC.swift
//  Alex Timer
//
//  Created by Austin Zheng on 6/20/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit

class SetAlarmVC: UIViewController {
    
    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    
    var setAlarmClosure: (Date, [Bool], String, Bool, String) -> (Void) = {_,_,_,_,_  in}
    var editAlarmClosure: (Date, [Bool], String) -> (Void) = {_,_,_ in}
    
    let AlarmVC = AlarmViewContoller()
    var setDate: Date = Date()
    var setReset: [Bool] = [false, false, false, false, false, false, false]
    var setLabel: String = "Alarm"
    var editingAlarm: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmDatePicker.date = setDate
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        setDate = alarmDatePicker.date
        print("first set date is: \(String(describing: setDate))")
        if editingAlarm == false {
            let setActive = true
            let setIdentifier = UUID().uuidString
            setAlarmClosure(setDate, setReset, setLabel, setActive, setIdentifier)
        } else {
            editAlarmClosure(setDate, setReset, setLabel)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func repeatButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SetRepeatVC")
        let setRepeatVC = viewController as! SetRepeatVC
        setRepeatVC.daysChecked = setReset
        
        self.present(setRepeatVC, animated: true, completion: nil)
        setRepeatVC.repeatClosure = {
            self.setReset = $0
        }
    }
    
    @IBAction func labelButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SetLabelVC")
        let setLabelVC = viewController as! SetLabelVC
        setLabelVC.label = setLabel
        self.present(setLabelVC, animated: true, completion: nil)
        setLabelVC.setLabelClosure = {
            self.setLabel = $0
        }
    }
    
    
    
    
    
}
