//
//  ViewController.swift
//  Advice
//
//  Created by Mitchell Socia on 6/13/19.
//  Copyright © 2019 Mitchell Socia. All rights reserved.
//

import UIKit

/*
 Different Ideas for separate PRs which you could get some reviews on
 🧹 = cleanup/tidy-up (whitespace, naming, formatting, etc.)
 🏗 = refactor idea 1: moving networking into a separate class
 🚧 = refactor idea 2: moving parsing-work into separate methods (likely also in the same class as your networking for now)
 ⛑ = refactor idea 3: Give the "getYoda" method a completion handler that passes along a string
 // exactly the same as what we did with the "getAdvice" method, and set your self.mainLabel.text in the completion handler of THAT method instead of the "getYoda" method.
 🚫👐 = Error Handling possibility
 */

class MainAdviceDisplayViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

