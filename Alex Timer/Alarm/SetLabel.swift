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
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        guard let label = labelTextField.text else {
            return
        }
        setLabelClosure(label)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var labelTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
