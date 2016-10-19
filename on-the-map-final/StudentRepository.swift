//
//  StudentRepository.swift
//  on-the-map-final
//
//  Created by modelf on 8/11/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation

class StudentRepository {
    
    var studentsLocations : [StudentInformation] = [StudentInformation]()
    var dataIsGood: Bool = false
    
    func populateStudents (completionHandler:(Bool, [StudentInformation]?, String?) -> ())
    {
        ParseClient.sharedInstance().getStudents() {(success, data, error) in
            if (success) {
                if let results = data!["results"] as? [AnyObject] {
                    for result in results {
                        let student = StudentInformation(dictionary: result as! NSDictionary)
                        self.studentsLocations.append(student)
                        for value in self.studentsLocations {
                            
                            // sometimes there are values with nil or "" values stored by students
                            // in the database which will cause my loading functions to crash.
                            
                            if value.firstName == nil || value.firstName == "" {
                                self.studentsLocations.popLast()
                            }
                            if value.lastName == nil || value.lastName == "" {
                                self.studentsLocations.popLast()
                            }
                            if value.latitude == nil || value.latitude == 0.0 {
                                self.studentsLocations.popLast()
                            }
                            if value.longitude == nil || value.longitude == 0.0 {
                                self.studentsLocations.popLast()
                            }
                            if value.mediaURL == nil || value.mediaURL == "" {
                                self.studentsLocations.popLast()
                            }
                            if value.mapString == nil || value.mapString == "" {
                                self.studentsLocations.popLast()
                            }
                        }
                    }
                }
                self.dataIsGood = true
                completionHandler(true, self.studentsLocations, nil)
            }
            else {
                completionHandler(false, nil, error?.localizedDescription)
            }
        }
    }
    
    class func sharedInstance() -> StudentRepository {
        
        struct Singleton {
            static var sharedInstance = StudentRepository()
        }
        
        return Singleton.sharedInstance
    }

    
}