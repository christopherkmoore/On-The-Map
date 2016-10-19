//
//  LocationViewController.swift
//  on-the-map-final
//
//  Created by modelf on 7/22/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    let app = UIApplication.sharedApplication().delegate as! AppDelegate

    var longitude: Double!
    var latitude: Double!
    var mapString: String!
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextField.delegate = self
        mapView.delegate = self
        print(self.mapString)
        print(self.longitude)
        print(self.latitude)
        print(app.accountKey)
        print(app.firstName)
        print(app.lastName)
    }
    
    @IBAction func submitURL(sender: UIButton) {
        

        let params: [String:AnyObject] = [

            "uniqueKey": app.accountKey,
            "firstName": app.firstName,
            "lastName": app.lastName,
            "mediaURL": urlTextField.text!,
            "latitude": self.latitude,
            "longitude": self.longitude,
            "mapString": self.mapString
            ]
        
            print(params)
        
        let student = StudentInformation(dictionary: params)
        ParseClient.sharedInstance().postStudent(student){(success, data, error) in
            if (success) {
                self.performSegueWithIdentifier("unwindToMap", sender: self)
            } else {
                Shared.displayErrorAsString(self, errorString: error)
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        urlTextField.text! = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if urlTextField.text! == "" {
            urlTextField.text! = "Enter a Link to Share:"
        }
    }
    
    func dismissKeyboard() {
        urlTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let annotations = MKPointAnnotation()
        annotations.coordinate = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
        annotations.title = "You are here ->"
        self.mapView.addAnnotation(annotations)
        
    }


}

