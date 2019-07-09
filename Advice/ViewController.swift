//
//  ViewController.swift
//  Advice
//
//  Created by Mitchell Socia on 6/13/19.
//  Copyright © 2019 Mitchell Socia. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var advice: Advice?
    
    @IBOutlet weak var mainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAdviceMethod()
        
    }
    
    func getAdviceMethod() {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: "https://api.adviceslip.com/advice") else {
            print("Error with the URL")
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            //JSONSerialization
            //step 1: Top Level json (allll the json coming back)
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] else {
                print("no json")
                return
            }
            
            //step 2: grab the first thing, which for us is some thing called a "slip" which has bits of advice in it
            guard let slipJSON = json["slip"] as? [String: Any] else {
                print("no slip")
                return
            }
            
            //step 3: gimme the value WITHIN that first thing (the slip) that has the key "advice"
            guard let advice = slipJSON["advice"] as? String else {
                print("no advice")
                return
            }
            
            //step 4: same as step 3 but gimme the value for this other key "slip_id"
            guard let slipID = slipJSON["slip_id"] as? String else {
                print("no slip_id")
                return
            }
            
            //step 5: now that we have the ingredients to make a new object, let's create one!
            let wonderfulAdvice = Advice(advice: advice, slipID: slipID)
            
            DispatchQueue.main.async {
                
                self.mainLabel.text = wonderfulAdvice.advice
                
            }
            
        }
        
        dataTask.resume()
    }
    
    
}

