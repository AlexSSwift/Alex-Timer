//
//  SetAlarmVC.swift
//  Alex Timer
//
//  Created by Austin Zheng on 6/20/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit

protocol SetAlarmResetDelegate {
    func reset(reset: [Bool])
}

class SetAlarmVC: UIViewController, AlarmDelegate {

    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    
    var setAlarmClosure: (Date, [Bool], String, Bool, String) -> (Void) = {_,_,_,_,_  in
    }

    var setDate: Date = Date()
    var setReset: [Bool] = [false, false, false, false, false, false, false]
    var setLabel: String = "Alarm"
    let AlarmVC = AlarmViewContoller()
    var editingAlarm: Bool = false
    var setAlarmResetDelegate: SetAlarmResetDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AlarmVC.alarmDelegate = self
    }
    
    func editAlarm(time: Date, resetDays: [Bool], label: String) {
        editingAlarm = true
        
        alarmDatePicker.date = time
        setReset = resetDays
        setLabel = label
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        setDate = alarmDatePicker.date
        print("first set date is: \(String(describing: setDate))")
        if editingAlarm == false {
            let setActive = true
            let setIdentifier = UUID().uuidString
            setAlarmClosure(setDate, setReset, setLabel, setActive, setIdentifier)
        } else {
            
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
        setAlarmResetDelegate.reset(reset: self.setReset)
        self.present(setRepeatVC, animated: true, completion: nil)
        setRepeatVC.repeatClosure = {
            self.setReset = $0
        }
    }
    
    @IBAction func labelButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SetLabelVC")
        let setLabelVC = viewController as! SetLabelVC
    
        self.present(setLabelVC, animated: true, completion: nil)
        setLabelVC.setLabelClosure = {
            self.setLabel = $0
        }
    }
    
    
    
    
    
}
