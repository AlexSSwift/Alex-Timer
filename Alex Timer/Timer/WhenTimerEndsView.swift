//
//  WhenTimerEndsView.swift
//  Alex Timer
//
//  Created by Austin Zheng on 6/12/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit
import AVFoundation

class WhenTimerEndsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var WhenTimerEndsTableView: UITableView!
    
    var alarms: [SystemSoundID] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell")!
        

        
       return cell
    }
    

    @IBAction func CancelButtonPressed(_ sender: UIButton) {
   self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func SetButtonPressed(_ sender: UIButton) {
    }
    
    
    
    
    
    
    
}
