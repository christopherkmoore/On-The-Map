//
//  UpdateLocationViewController.swift
//  on-the-map-final
//
//  Created by modelf on 7/20/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class UpdateLocationViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
      @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func dimiss(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitAddress(sender: UIButton) {
        activityIndicator.startAnimating()
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(searchTextField.text!, completionHandler: {(placemarks, error) in
            if error == nil {
                let placemarks = placemarks![0]
                if let mapString = placemarks.locality {
                    let params : [String:AnyObject] = [
                        "latitude": placemarks.location!.coordinate.latitude,
                        "longitude": placemarks.location!.coordinate.longitude,
                        "mapString": "\(mapString)"
                    ]
                    Shared.createLocSegue(self, data: params)
                }
            }

            if error != nil {
                    Shared.displayError(self, errorString: error)
                }

            self.activityIndicator.stopAnimating()
        })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        searchTextField.text! = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if searchTextField.text! == "" {
            searchTextField.text! = "Where are you studying today?"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
        print("keyboard returning frame")
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if (UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            if searchTextField.isFirstResponder() {
                view.frame.origin.y = -getKeyboardHeight(notification)
                print("keyboard moving frame")
            }
        }
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func dismissKeyboard() {
        searchTextField.resignFirstResponder()
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "keyboardWillShow:", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "keyboardWillHide:", object: nil)
    }
    

}
