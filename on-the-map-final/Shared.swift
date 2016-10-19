//
//  SharedSegues.swift
//  on-the-map-final
//
//  Created by modelf on 7/25/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import UIKit

class Shared: NSObject {
    
    class func performUIUpdatesOnMain(updates: () -> Void) {
        dispatch_async(dispatch_get_main_queue()){
            updates()
        }
    }
    
    
    class func createLocSegue(vc: UIViewController, data: [String:AnyObject]) {
        let controller = vc.storyboard!.instantiateViewControllerWithIdentifier("LocationViewController") as! LocationViewController
        controller.mapString = data["mapString"] as! String
        controller.latitude = data["latitude"] as! Double
        controller.longitude = data["longitude"] as! Double
        vc.presentViewController(controller, animated: true, completion: nil)
    }
    
    class func createEditSegue(vc: UIViewController) {
        let locationController = vc.storyboard?.instantiateViewControllerWithIdentifier("UpdateLocationViewController") as! UpdateLocationViewController
        vc.presentViewController(locationController, animated: true, completion: nil)
    }
    
    class func displayError(vc: UIViewController, errorString: NSError?) {
        if let errorString = errorString {
            dispatch_async(dispatch_get_main_queue()) {
                let alertController = UIAlertController(title: "Error", message: errorString.localizedDescription, preferredStyle: .Alert)
                let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: {(paramAction:UIAlertAction!) in print(paramAction.title)})
                
                alertController.addAction(action)
                vc.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    class func displayErrorAsString(vc: UIViewController, errorString: String?) {
        if let errorString = errorString {
            dispatch_async(dispatch_get_main_queue()) {
                let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .Alert)
                let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: {(paramAction:UIAlertAction!) in print(paramAction.title)})
                
                alertController.addAction(action)
                vc.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}