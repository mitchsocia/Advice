//
//  ViewController.swift
//  Advice
//
//  Created by Mitchell Socia on 6/13/19.
//  Copyright © 2019 Mitchell Socia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
            if error != nil {
                print(error!)
            } else {
                do {
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

