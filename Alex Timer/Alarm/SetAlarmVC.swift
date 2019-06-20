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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    
     self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
    
    self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
