//
//  File.swift
//  on-the-map-final
//
//  Created by modelf on 7/17/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import UIKit

class ParseClient: NSObject {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // find a better spot.
    
    func getStudents(completionHandler: (success: Bool, data: [String:AnyObject]?, error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, data: nil, error: error)
                return
            } else {
                let parsedData : [String:AnyObject]
                do {
                    parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [String:AnyObject]
                } catch {
                    print("could not parse")
                    return
                }
                completionHandler(success: true, data: parsedData, error: nil)
                
            }
        }
        task.resume()
    }
    
    func getStudent(uniqueKey: String, completionHandler: (success: Bool, data: [String:AnyObject]) -> Void ) {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey\(uniqueKey)"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, data: ["error": "\(error!.localizedDescription)"])
                return
            } else {
                let parsedData : [String:AnyObject]
                do {
                    parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [String:AnyObject]
                } catch {
                    print("could not parse")
                    return
                }
            completionHandler(success: true, data: parsedData)
            }
        }
        task.resume()
    }
    
    func postStudent(studentInfo: StudentInformation, completionHandler: (success: Bool, data: AnyObject!, error: String? ) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"uniqueKey\" : \"\(studentInfo.uniqueKey!)\", \"firstName\" : \"\(studentInfo.firstName!)\", \"lastName\" : \"\(studentInfo.lastName!)\", \"mapString\" : \"\(studentInfo.mapString!)\", \"mediaURL\" : \"\(studentInfo.mediaURL!)\", \"latitude\" : \(studentInfo.latitude!), \"longitude\" : \(studentInfo.longitude!)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard (error == nil) else {
                completionHandler(success: false, data: nil, error: "There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completionHandler(success: false, data: nil, error: "There was an error with the data: \(error!.localizedDescription)")
                return
            }

            var parsedData: AnyObject!
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String:AnyObject]
            } catch {
                completionHandler(success: false, data: nil, error: "There was an error parsing the data: \(data)")
            }

            completionHandler(success: true, data: parsedData, error: nil)
            
        }
        task.resume()
        return task
    }
    
    func putStudent(uniqueKey: String, studentInfo: StudentInformation, completionHandler: (success: Bool, data: AnyObject!, error: String? ) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation/")!)
        
        request.HTTPMethod = "PUT"
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let uniqueKey = appDelegate.accountKey
        
        request.HTTPBody = "{\"uniqueKey\" : \"\(studentInfo.uniqueKey)\", \"firstName\" : \"\(studentInfo.firstName)\", \"lastName\" : \"\(studentInfo.lastName)\", \"mapString\" : \"\(studentInfo.mapString)\", \"mediaURL\" : \"\(studentInfo.mediaURL)\", \"latitude\" : \(studentInfo.latitude), \"longitude\" : \(studentInfo.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard (error == nil) else {
                completionHandler(success: false, data: nil, error: "There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completionHandler(success: false, data: nil, error: "There was an error with the data: \(error!.localizedDescription)")
                return
            }
            
            var parsedData: AnyObject!
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String:AnyObject]
            } catch {
                completionHandler(success: false, data: nil, error: "There was an error parsing the data: \(data)")
            }
            print(parsedData)
            completionHandler(success: true, data: parsedData, error: nil)
            
        }
        task.resume()
        return task
    }
 
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
}












