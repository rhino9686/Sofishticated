//
//  Messenger.swift
//  FishTank
//
//  Created by Robert Cecil on 10/23/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import Foundation

final class Messenger {
    
    //IP Address of target Server
    private var ipAddress: String
    
    //Something to hold the result of a Get request
    private var result: String = "Result Placeholder"
    
    //Constructor
    init(ipAddress: String ) {
        self.ipAddress = ipAddress
    }
    
    
     func printMessagesForUser() -> Void {
        
        let json = ["user":"larry"]
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let url = URL(string: "http://0.0.0.0:5000/api/get_messages")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                if error != nil{
                    print("Error -> \(String(describing: error))")
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    print("Result -> \(String(describing: result))")
                } catch {
                    print("Error -> \(error)")
                }
            }
            task.resume()
        } catch {
            print(error)
        }
    }
    
    
    func sendRequest(param: String, route: String) -> String  {
        
        let json = ["query":param]
        
        var HttpResult: String = "Error"
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            let urlString =   "http://" + self.ipAddress + route
            let url = URL(string: urlString)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            
            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                if error != nil{
                    print("Error -> \(String(describing: error))")
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    print("Result -> \(String(describing: result))")
                    HttpResult = (String(describing: result))
                    
                } catch {
                    print("Error -> \(error)")
                }
            }
            task.resume()
        } catch {
            print(error)
            
        }
        return HttpResult
    }
    
    
    
    func requestRando() -> String {
        return sendRequest(param: "rando", route: "fromApp/getRando")
    }
    
    
    
    // Requests the Tanks's pH from the server
    func requestPh() -> String {
         return sendRequest(param: "pH", route: "fromApp/getPH")
    }
    
    // Requests the Tank's Temperature from the server
    func requestTemp() -> String {
        return sendRequest(param: "Temp", route: "fromApp/getTemp")
    }
    
    
}
