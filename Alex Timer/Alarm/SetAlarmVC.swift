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
    
    var setAlarmClosure: (Date, [Bool], String) -> (Void) = {_,_,_ in 
        
    }
    //    var resetClosure: (([Bool]) -> Void)!
    var setDate: Date = Date()
    var setReset: [Bool] = []
    var setLabel: String = "Alarm"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        setAlarmClosure(setDate, setReset, setLabel)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func repeatButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SetRepeatVC")
        let setRepeatVC = viewController as! SetRepeatVC
    
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
