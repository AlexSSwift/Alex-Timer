//
//  SetLabel.swift
//  Alex Timer
//
//  Created by Austin Zheng on 7/8/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit

class SetLabelVC: UIViewController {
    
    var setLabelClosure: ((String) -> Void)!
    @IBOutlet weak var labelTextField: UITextField!
    var label: String = ""
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        guard let label = labelTextField.text else {
            return
        }
        setLabelClosure(label)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTextField.text = label
    }
    
}
