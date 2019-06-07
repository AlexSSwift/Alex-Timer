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

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
   
    @IBOutlet weak var timerTimePicker: UIPickerView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLabelView: UIView!
  
    var timer = Timer()
    var currentHour = 00
    var currentMinute = 00
    var currentSecond = 00
    let hours = [00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    let minutes = [00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
    let seconds = [00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
    

    @IBAction func startPauseResumeButtonPressed(_ sender: UIButton) {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.action), userInfo: nil, repeats: true)
        timeLabelView.isHidden = false
        
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        timer.invalidate()
        timeLabelView.isHidden = true
   
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numberOfRows: Int = 0
        if component == 0 {
            numberOfRows = hours.count
        } else if component == 1 {
            numberOfRows = minutes.count
        } else if component == 2 {
            numberOfRows = seconds.count
        } else {
            print("error: couldn't get number of rows")
        }
        return numberOfRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      //  let time: [[Int]] = [hours, minutes, seconds]

        var numbers: String = ""
        if component == 0 {
            numbers = "\(hours[row])"
        } else if component == 1 {
            numbers = "\(minutes[row])"
        } else if component == 2 {
            numbers = "\(seconds[row])"
        } else {
            print("error: couldn't get data")
        }
        return numbers
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentHour = hours[pickerView.selectedRow(inComponent: 0)]
        currentMinute = minutes[pickerView.selectedRow(inComponent: 1)]
        currentSecond = seconds[pickerView.selectedRow(inComponent: 2)]
        let time = String(format: "%02d:%02d:%02d", self.currentHour, self.currentMinute, self.currentSecond)
        timeLabel.text = time
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timerTimePicker.delegate = self
        timerTimePicker.dataSource = self
        
    }
    
    @objc func action(){
        //if seconds reaches 00 and minute is not 00, reduce minutes by 1 and set seconds to 59. if minutes reach 00 and hours is not 00, reduce hours by 1 and set minutes to 59.
        currentSecond -= 1
        
        if currentSecond == 00 {
            if currentMinute != 00 {
                currentMinute -= 1
                currentSecond = 59
            } else {
                timer.invalidate()
                AudioServicesPlayAlertSound(SystemSoundID(1304))
            }
        }
        if currentMinute == 00 {
            if currentHour != 00 {
                currentHour -= 1
                currentMinute = 59
            }
        }
        
        let time = String(format: "%02d:%02d:%02d", self.currentHour, self.currentMinute, self.currentSecond)
        timeLabel.text = time
    }
    
    

}

//
//  PickerLabels.swift
//  My Timer
//
//  Created by Luís Machado on 02/02/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//
import Foundation
import UIKit


extension UIPickerView {
    
    func setPickerLabels(labels: [Int:UILabel], containedView: UIView) { // [component number:label]
        
        let fontSize:CGFloat = 20
        let labelWidth:CGFloat = containedView.bounds.width / CGFloat(self.numberOfComponents)
        let x:CGFloat = self.frame.origin.x
        let y:CGFloat = (self.frame.size.height / 2) - (fontSize / 2)
        
        for i in 0...self.numberOfComponents {
            
            if let label = labels[i] {
                
                if self.subviews.contains(label) {
                    label.removeFromSuperview()
                }
                
                label.frame = CGRect(x: x + labelWidth * CGFloat(i), y: y, width: labelWidth, height: fontSize)
                label.font = UIFont.boldSystemFont(ofSize: fontSize)
                label.backgroundColor = .clear
                label.textAlignment = NSTextAlignment.center
                
                self.addSubview(label)
            }
        }
    }
}
