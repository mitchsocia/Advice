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

// 🧹 Rename to something less generic
class ViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAdviceMethod { (advice) in
            // 🧹  try not to use a force unwrap here, 🚫👐 show something else (an alert perhaps!?) if Advice is nil
            self.getYoda(advice: advice!)
        }
    }
    
        // 🏗 Move this and the Advice method into one single, separate class for now (you can call it NetworkingManager or AdviceService for now). This will start to get at the concept of a "Networking" layer, and removing methods that make api calls from your ViewControllers. Hooking things back up might throw you for a loop, but it's a great exercise!
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
            if error != nil {
                print(error!)
            } else {
                do {// 🧹 This "do" block can be removed if you make this next line a guard statement. (guard let yodaJSON = ...)
                    // 🚧 this whole block of code looks like it does something specific: parse data into a string. This code should be in its own method: something like: yodaTranslation(from data: Data?) -> YodaTranslation
                    let yodaJSON = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                    guard let yodasVersion = yodaJSON?["contents"] as? [String:Any] else {
                        print("NO JSON")
                        return
                    }
                    print(yodasVersion)
                    let normalText = yodasVersion["text"] as! String
                    print(normalText)
                    let translatedYodaSpeak = yodasVersion["translated"] as! String
                    print(translatedYodaSpeak)
                    
                    // ⛑ refactor idea 3: add a completion handler to this getYoda method and move this UI-updating code into the caller's completion block (looks like you're calling this method in viewDidLoad: once you add a completion handler to this method you should be able to move it!
                    DispatchQueue.main.async {
                        self.mainLabel.text = translatedYodaSpeak
                    }
                    
                }
            }
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
            
            // 🚧 this whole completion block is parsing data into Advice. This would be perfect for a separate method, exactly as mentioned in the getYoda method above. Something like: advice(from data: Data?) -> Advice
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] else {
                print("no json")
                completion(nil)
                return
            }
            
            guard let slipJSON = json["slip"] as? [String: Any] else {
                print("no slip")
                completion(nil)
                return
            }
            
            guard let advice = slipJSON["advice"] as? String else {
                print("no advice")
                completion(nil)
                return
            }
            
            guard let slipID = slipJSON["slip_id"] as? String else {
                print("no slip_id")
                completion(nil)
                return
            }
            
            let wonderfulAdvice = Advice(advice: advice, slipID: slipID)
            completion(wonderfulAdvice.advice)
            
        }
        
        dataTask.resume()
    }
    
    
}

