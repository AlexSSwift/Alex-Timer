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
    let hours = Array(0...23)
    let minutes = Array(0...59)
    let seconds = Array(0...59)
    
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
