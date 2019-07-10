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
    
    //var advice: Advice?
    
    @IBOutlet weak var mainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAdviceMethod { (advice) in
            self.getYoda(advice: advice!)
        }
        
    }
    
    func getYoda(advice: String) {
        
        //URL Components:
        var components = URLComponents(string: "https://api.funtranslations.com/translate/yoda.json")
        let queryItem = URLQueryItem(name: "text", value: advice)
        components?.queryItems = [queryItem]
        guard let url = components?.url else { return }
        let request = URLRequest(url: url)
        
        //Session:
        let session = URLSession.shared
        
        //Data task
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            guard let yodaJSON = try? JSONSerialization.jsonObject(with: data!, options: []) else {
                print("No Yoda JSON")
                return
            }
            print(yodaJSON)
        }
        dataTask.resume()
    }
    
    
    func getAdviceMethod(completion: @escaping (String?) -> ()) {
        
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
                completion(nil)
                return
            }
            
            //step 2: grab the first thing, which for us is some thing called a "slip" which has bits of advice in it
            guard let slipJSON = json["slip"] as? [String: Any] else {
                print("no slip")
                completion(nil)
                return
            }
            
            //step 3: gimme the value WITHIN that first thing (the slip) that has the key "advice"
            guard let advice = slipJSON["advice"] as? String else {
                print("no advice")
                completion(nil)
                return
            }
            
            //step 4: same as step 3 but gimme the value for this other key "slip_id"
            guard let slipID = slipJSON["slip_id"] as? String else {
                print("no slip_id")
                completion(nil)
                return
            }
            
            //step 5: now that we have the ingredients to make a new object, let's create one!
            let wonderfulAdvice = Advice(advice: advice, slipID: slipID)
            completion(wonderfulAdvice.advice)
            
            //                                    DispatchQueue.main.async {
            //
            //                                        self.mainLabel.text = wonderfulAdvice.advice
            //
            //                                    }
            
        }
        
        dataTask.resume()
    }
    
    
}

