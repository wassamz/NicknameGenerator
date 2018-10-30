//
//  ViewController.swift
//  Nickname Generator
//
//  Created by Wassam Zahreddine on 2018-10-28.
//  Copyright © 2018 Wassam Zahreddine. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var outputField: NSTextField!
    @IBAction func goButtonClicked(_ sender: Any) {
        displayNickName()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func displayNickName() {
        URLSession.shared.dataTask(with: createRequest(url: buildURL())) { (data, urlResponse, error) in
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            do
            {
                guard let responseJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                    else {
                        print("Could not get JSON from responseData")
                        return
                }
                
                let nickName = responseJSON["nickname"] as! String
                
                DispatchQueue.main.async {
                    self.outputField.stringValue = "\(nickName)";
                }
            } catch let err{
                print("JSON Serialization error \(err)")
            }
            }.resume()
        
    }
    
    func buildURL() -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.codetunnel.net"
        urlComponents.path = "/random-nick"
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        return url
    }
    
    func createRequest( url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonData: Data
        let blankData: [String: Any] = ["": ""]
        do {
            jsonData = try JSONSerialization.data(withJSONObject: blankData, options: [])
            request.httpBody = jsonData
        } catch let err{
            print(err)
        }
        return request
    }
    
}

