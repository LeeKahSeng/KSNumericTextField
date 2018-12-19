//
//  ViewController.swift
//  KSNumericTextFieldExample
//
//  Created by Lee Kah Seng on 17/03/2018.
//  Copyright © 2018 Lee Kah Seng. All rights reserved.
//

import UIKit
import KSNumericTextField

class ViewController: UIViewController {
    
    @IBOutlet weak var doubleDigitTextField: KSNumericTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set integer digit & fraction digit
        doubleDigitTextField.maxIntegerDigit = 2
        doubleDigitTextField.maxFractionDigit = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

