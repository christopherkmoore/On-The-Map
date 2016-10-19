//
//  MapViewController.swift
//  on-the-map-final
//
//  Created by modelf on 7/17/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func showLocController(sender: UIBarButtonItem) {
        Shared.createEditSegue(self)
    }
    
    
    @IBAction func logout(sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().logout(){(success, data, error) in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                Shared.displayError(self, errorString: error)
            }
        }
    }
    @IBAction func refresh(sender: UIBarButtonItem) {
        refreshStudents()
    }
    @IBAction func unwindToMap(sender: UIStoryboardSegue) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        mapView.delegate = self
    }
    
    func loadData () {

        let studentRepo = StudentRepository.sharedInstance()
        if studentRepo.dataIsGood == true {
            self.createPins(studentRepo.studentsLocations)
        } else {
            self.refreshStudents()
            
        }
        
    }
    func refreshStudents() {
        StudentRepository.sharedInstance().populateStudents {(success, data, error) in
            print(success)
            if (success) {
                Shared.performUIUpdatesOnMain(){
                    self.createPins(data!)
                }
            }
            else {
                Shared.displayErrorAsString(self, errorString: error)
            }
        }
    }
    
    func createPins(data: [StudentInformation]) {
        var annotations = [MKPointAnnotation]()
        if let data = data as [StudentInformation]! {
        
            for student in data {
                let latitude = CLLocationDegrees(student.latitude!)
                let longitude = CLLocationDegrees(student.longitude!)
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = student.fullName
                annotation.subtitle = student.mediaURL
                annotations.append(annotation)
            
            }
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
        }
    }
    

  
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = NSURL(string: ((view.annotation?.subtitle)!)!) {
                if app.canOpenURL(toOpen){
                    app.openURL(toOpen)
                }else{
                    Shared.displayErrorAsString(self, errorString: "Cannot load URL")
                }
            }
        }
    }

}