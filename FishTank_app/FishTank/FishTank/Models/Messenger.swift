//
//  Messenger.swift
//  FishTank
//
//  Created by Robert Cecil on 10/23/19.
//  Copyright © 2019 Robert Cecil. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class Messenger {
    
    //Published vars to change and send out the data to observers
    @Published var currentTempF: Double = 0
    @Published var currentPh: Double = 7.0
    @Published var lastCheckedTimeInMins = 3
    
    //IP Address of target server
    private var ipAddress: String
    //Port number of target server
    private var port: String = ":5000"
    
    //Something to hold the result of a Get request
    private var result: String = "Result Placeholder"
    
    //Constructor
    init(ipAddress: String) {
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
        
        var HttpResult: String = "Nothing received"
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            let urlString =  "http://" + self.ipAddress + self.port + route
            let url = URL(string: urlString)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
                if error != nil{
                    print("Error -> \(String(describing: error))")
                    return
                }
                
                if response == nil {
                    print("Empty Response")
                    return
                }
                guard let data = data else {
                    print("Empty Data")
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                    if result != nil {
                        let Val = result?[param] as! String
                        
                        HttpResult = Val
                        print(Val)
                        if param == "pH" {
                            self.parsePh(param: param, httpResult: HttpResult)
                        }
                        else if param == "temp" {
                            self.parseTemp(param: param, httpResult: HttpResult)
                        }
                        print("Result -> \(String(describing: result))")
                    
                    }

                } catch {
                    print("Error -> \(error)")
                }
            }
            
            //This is for testing the server connection
            task.resume()
            usleep(200000)
            return HttpResult
        } catch {
            print(error)
            
        }
        return HttpResult
    }
    
    
    
    func requestRando() -> String {
        return sendRequest(param: "randVal", route: "/fromApp/requestRando")
    }
    
    
    // Requests the Tanks's pH from the server
    func requestPh() -> String {
         return sendRequest(param: "pH", route: "/fromApp/requestpH")
    }
    
    // Requests the Tank's Temperature from the server
    func requestTemp() -> String {
        return sendRequest(param: "temp", route: "/fromApp/requestTemp")
    }
    
    
    func refreshParams() {
 
       var _ = self.requestPh()
       var _ = self.requestTemp()
    }
    
    
    func parsePh(param: String, httpResult: String ) {
        
        let numDouble: Double? = Double(httpResult)
            
        if (numDouble != nil) {
            //Here we make the final correction to make the number a decimal
            let truepH = numDouble! / 100
            //Make sure this works
            self.currentPh = truepH
        }
    }
    
    func parseTemp(param: String, httpResult: String ) {
        // Make sure that the httpString value contains an actual number
       // print(httpResult)
        
        let numDouble: Double? = Double(httpResult)
            
        if (numDouble != nil) {
           //Here we make the final correction to make the number a decimal
           let trueTemp = numDouble! / 100
           self.currentTempF = (trueTemp)
        }
    }
    
}
