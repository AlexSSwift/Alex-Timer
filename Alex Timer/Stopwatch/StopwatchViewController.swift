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
    enum startPauseResume {case start, pause, resume}
    var buttonStatus:startPauseResume = startPauseResume.start
    @IBOutlet weak var startButtonProperties: UIButton!
    
    @IBAction func startStopButtonPressed(_ sender: Any) {
       timerRun()
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        timer.invalidate()
        let time = String(format: "%02d:%02d:%02d", 0, 0, 0)
        stopwatchTimeLabel.text = time
        buttonStatus = startPauseResume.start
        currentHour = 0
        currentMinute = 0
        currentSecond = 0
        startButtonProperties.setTitle(_: "Start", for: UIControl.State.normal)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
        func timerRun() {
    
            if buttonStatus == startPauseResume.start {
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(TimerViewContoller.action), userInfo: nil, repeats: true)
                startButtonProperties.setTitle(_: "Pause", for: UIControl.State.normal)
                buttonStatus = startPauseResume.pause
            } else if buttonStatus == startPauseResume.pause {
                timer.invalidate()
                startButtonProperties.setTitle(_: "Resume", for: UIControl.State.normal)
                buttonStatus = startPauseResume.resume
            } else if buttonStatus == startPauseResume.resume {
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(TimerViewContoller.action), userInfo: nil, repeats: true)
                startButtonProperties.setTitle(_: "Pause", for: UIControl.State.normal)
                buttonStatus = startPauseResume.pause
            }
    
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
