//
//  UdacityClient.swift
//  on-the-map-final
//
//  Created by modelf on 7/17/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient: NSObject {
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var session = NSURLSession()
    var UserID: String = ""
    
    var loginError: String?
    
    var accountKey : String = ""
    var firstName : String = ""
    var lastName : String = ""
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    

    func login(username: String, password: String, completionHandler: (success: Bool, error: String?, accKey: String?) -> Void ) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            //check error
            guard (error == nil) else {
                completionHandler(success: false, error: "There was an error with your request: \(error)", accKey: nil)
                return
            }
            //check data
            guard let data = data else {
                completionHandler(success: false, error: "There was an error with your data: \(error)", accKey: nil)
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            var jsonData : AnyObject!
            do {
                jsonData = try NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments)

            } catch {
                completionHandler(success: false, error: "Error in Parsing data", accKey: nil)
                return
            }
            if let item = jsonData as? [String: AnyObject] {
                if let session = item["session"] as? [String: AnyObject] {
                    
                    self.loginError = "Account Valid"
                    self.UserID = ((jsonData["account"] as! [String:AnyObject])["key"] as! String)
                }
                else  {
                    self.loginError = "Account Invalid"
                }
            }
            
            self.appDelegate.accountKey = self.UserID
            completionHandler(success: true, error: self.loginError, accKey: self.UserID)
            
        }
        task.resume()
    }
    
    func getUserData (uniqueKey: String, completionHandler: (success: Bool, data: [String:AnyObject]) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(uniqueKey)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, data: ["error" : "\(error?.localizedDescription)"])
                return
            } else {
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                let jsonData : [String:AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! [String:AnyObject]
                } catch {
                    completionHandler(success: false, data: ["error": "couldn't parse data"])
                    return
                }
                completionHandler(success: true, data: jsonData)
            }
        }
        task.resume()
    }
    
    func logout(completionHandler: (Bool, AnyObject?, NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("error logging out")
                completionHandler(false, nil, error!)
            }
            
            let parsingError : NSError? = nil
            if let data = data {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                do {
                    let _ = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! [String:AnyObject] }
                catch {
                    print("error parsing data: \(parsingError)" )
                }
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.firstName = ""
                appDelegate.lastName = ""
                appDelegate.accountKey = ""
                completionHandler(true, newData, nil)
            }
            
        }
        task.resume()
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }

}
















