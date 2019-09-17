//
//  ViewController.swift
//  Alex Timer
//
//  Created by Austin Zheng on 5/31/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class TimerViewContoller: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
   
    @IBOutlet weak var timerTimePicker: UIPickerView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLabelView: UIView!
    @IBOutlet weak var hoursPickerLabel: UILabel!
    @IBOutlet weak var minutesPickerLabel: UILabel!
    @IBOutlet weak var secondsPickerLabel: UILabel!
    @IBOutlet weak var pickerLabelView: UIView!
    @IBOutlet weak var startButtonProperties: UIButton!
    enum startPauseResume {case start, pause, resume}
    var buttonStatus:startPauseResume = startPauseResume.start
    var timer = Timer()
    var currentHour = 00
    var currentMinute = 00
    var currentSecond = 00
    let hours = Array(0...23)
    let minutes = Array(0...59)
    let seconds = Array(0...59)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerLabels: [Int:UILabel] = [1:hoursPickerLabel, 3: minutesPickerLabel, 5:secondsPickerLabel]
        timerTimePicker.delegate = self
        timerTimePicker.dataSource = self
        timerTimePicker.setPickerLabels(labels: pickerLabels, containedView: self.view)
        
    }
    
    @IBAction func startPauseResumeButtonPressed(_ sender: UIButton) {
        if currentHour == 0 && currentMinute == 0 && currentSecond == 0 {
            return
        } else {
            timeLabelView.isHidden = false
            timerTimePicker.isHidden = true
            timerRun()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        timer.invalidate()
        timerTimePicker.isHidden = false
        timeLabelView.isHidden = true
        currentHour = hours[timerTimePicker.selectedRow(inComponent: 0)]
        currentMinute = minutes[timerTimePicker.selectedRow(inComponent: 2)]
        currentSecond = seconds[timerTimePicker.selectedRow(inComponent: 4)]
        timeForTimeLabel()
        startButtonProperties.setTitle(_: "Start", for: UIControl.State.normal)
        buttonStatus = startPauseResume.start
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numberOfRows: Int = 0
        if component == 0 {
            numberOfRows = hours.count
        } else if component == 2 {
            numberOfRows = minutes.count
        } else if component == 4 {
            numberOfRows = seconds.count
        } else if component == 1 || component == 3 || component == 5 {
        //do nothing
        } else {
            print("error: couldn't get number of rows")
        }
        return numberOfRows
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentHour = hours[pickerView.selectedRow(inComponent: 0)]
        currentMinute = minutes[pickerView.selectedRow(inComponent: 2)]
        currentSecond = seconds[pickerView.selectedRow(inComponent: 4)]
        timeForTimeLabel()
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var numbers: String = ""
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
        ]
        var finalString: NSAttributedString!
        
        if component == 0 {
            numbers = "\(hours[row])"
           finalString = NSAttributedString(string: numbers, attributes: attributes)
        } else if component == 2 {
            numbers = "\(minutes[row])"
             finalString = NSAttributedString(string: numbers, attributes: attributes)
        } else if component == 4 {
            numbers = "\(seconds[row])"
           finalString = NSAttributedString(string: numbers, attributes: attributes)
        } else {
            print("error: couldn't get data")
        }
        return finalString

    }
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        <#code#>
//    }
   
    func timeForTimeLabel() {
        let time = String(format: "%02d:%02d:%02d", self.currentHour, self.currentMinute, self.currentSecond)
        timeLabel.backgroundColor = .black
        timeLabel.text = time
        timeLabel.textColor = .white
    }
    
    func timerRun() {
        
        if buttonStatus == startPauseResume.start {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerViewContoller.action), userInfo: nil, repeats: true)
            startButtonProperties.setTitle(_: "Pause", for: UIControl.State.normal)
            buttonStatus = startPauseResume.pause
        } else if buttonStatus == startPauseResume.pause {
            timer.invalidate()
             startButtonProperties.setTitle(_: "Resume", for: UIControl.State.normal)
            buttonStatus = startPauseResume.resume
        } else if buttonStatus == startPauseResume.resume {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerViewContoller.action), userInfo: nil, repeats: true)
            startButtonProperties.setTitle(_: "Pause", for: UIControl.State.normal)
            buttonStatus = startPauseResume.pause
        }
        
    }
    
    @objc func action(){
        //if seconds reaches 00 and minute is not 00, reduce minutes by 1 and set seconds to 59. if minutes reach 00 and hours is not 00, reduce hours by 1 and set minutes to 59.
        var timerDone = false
        
        if currentSecond == 00 {
            if currentMinute == 00 {
                if currentHour != 00 {
                    currentHour -= 1
                    currentMinute = 59
                    currentSecond = 60
                }
            }
        }
        if currentSecond == 00 {
            if currentMinute != 00 {
                currentMinute -= 1
                currentSecond = 60
            }
        }
        if currentHour == 0 && currentMinute == 0 && currentSecond == 0 {
            //what happens when the timer ends
            timer.invalidate()
            AudioServicesPlayAlertSound(SystemSoundID(1304))
            timerDone = true
        }
        
        if timerDone == false {
            currentSecond -= 1
        }
     timeForTimeLabel()
    }
    


}
//extension UIPickerView {
//
//    func addPickerLabels(labels: [Int:UILabel], containtedView: UIView) {
//
//        let fontSize: CGFloat = 17
//       // let LabelWidth: CGFloat =
//        let x: CGFloat = self.frame.origin.x
//        //let y: CGFloat =
//
//        let hours = labels[0]
//        let minutes = labels[1]
//        let seconds = labels[3]
//
//
//
//    }
//
//
//}
//
//  PickerLabels.swift
//  My Timer
//
//  Created by Luís Machado on 02/02/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

extension UIPickerView {
    
    func setPickerLabels(labels: [Int:UILabel], containedView: UIView) { // [component number:label]
        
        let fontSize:CGFloat = 17
        let labelWidth:CGFloat = containedView.bounds.width / CGFloat(self.numberOfComponents)
        let x:CGFloat = self.frame.origin.x
        let y:CGFloat = (self.frame.size.height / 2) - (fontSize / 2)
        
        for i in 0..<self.numberOfComponents {
            
            if let label = labels[i] {
                
                if self.subviews.contains(label) {
                    label.removeFromSuperview()
                }
                
                label.frame = CGRect(x: x + labelWidth * CGFloat(i), y: y, width: labelWidth, height: fontSize)
                label.textColor = .white
                label.backgroundColor = .clear
                label.textAlignment = NSTextAlignment.center
                
                self.addSubview(label)
            }
        }
    }
}
