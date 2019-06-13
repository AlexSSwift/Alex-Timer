//
//  StopwatchViewController.swift
//  Alex Timer
//
//  Created by Austin Zheng on 6/13/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit

class StopwatchViewController: UIViewController {
    
    @IBOutlet weak var stopwatchTimeLabel: UILabel!
    var timer = Timer()
    var currentHour = 00
    var currentMinute = 00
    var currentSecond = 00
    let hours = [00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    let minutes = [00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
    let seconds = [00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
    
    @IBAction func startStopButtonPressed(_ sender: Any) {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.action), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
    
    timer.invalidate()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func action() {
        
        currentSecond += 1
        
        if currentSecond == 59 {
            if currentMinute != 59 {
                currentMinute += 1
                currentSecond = 0
            }
        }
        if currentMinute == 59 {
            currentHour += 1
            currentMinute = 0
            
        }
        
        let time = String(format: "%02d:%02d:%02d", self.currentHour, self.currentMinute, self.currentSecond)
        stopwatchTimeLabel.text = time
        
    }
    
    
}
