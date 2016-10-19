//
//  ViewController.swift
//  on-the-map-final
//
//  Created by modelf on 7/17/16.
//  Copyright © 2016 modelf. All rights reserved.
//
import Foundation
import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityspinner: UIActivityIndicatorView!
    
    var session : NSURLSession!
    var ID = UdacityClient.sharedInstance().UserID

    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    //still kind of buggy
    
    @IBAction func sendButton (sender: UIButton) {
        self.view.endEditing(true)
        errorLabel.text = ""
        if usernameField.text! == "username" || passwordField.text! == "password" {
            errorLabel.text = "Please fill in the username and password fields."
        } else {
            activityspinner.startAnimating()
            UdacityClient.sharedInstance().login(usernameField.text!, password: passwordField.text!) {(success, error, accKey) in
                dispatch_async(dispatch_get_main_queue(), {
                if success {
                    if (error == "Account Invalid") {
                        self.errorLabel.text = "Invalid Account (username/password incorrect)"
                        self.activityspinner.stopAnimating()
                        return
                    }
                    else if (error == "Account Valid") {
                        self.finishLoading(accKey!)
                        self.segueToTabBar()
                    }
                }
                else {
                    Shared.displayErrorAsString(self, errorString: "Connection timed out")
                }
                self.activityspinner.stopAnimating()
            })
            }
        }
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if usernameField.text! == "" || passwordField.text! == "" {
            usernameField.text = "username"
            passwordField.text = "password"
        }
    }
    
    func segueToTabBar () {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabController") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func finishLoading(accKey: String) {
        UdacityClient.sharedInstance().getUserData(accKey){(success, data) in
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            if let user = data["user"] as? [String:AnyObject] {
                appDelegate.accountKey = user["key"] as! String
                appDelegate.firstName = user["first_name"] as! String
                appDelegate.lastName = user["last_name"] as! String
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if usernameField.text == "username" || passwordField.text == "password" {
            textField.text = ""
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session = NSURLSession.sharedSession()
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        loginButton.layer.cornerRadius = 5
        activityspinner.hidden = true

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

