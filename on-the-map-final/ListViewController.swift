//
//  ListViewController.swift
//  on-the-map-final
//
//  Created by modelf on 7/18/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func showLocController (sender: UIBarButtonItem) {
        Shared.createEditSegue(self)
    }
    
    @IBAction func refreshStudents () {
        renewStudents()
    }
    var studentLocation = StudentRepository.sharedInstance().studentsLocations
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadStudents()
    }
    
    func loadStudents() {
        let studentRepo = StudentRepository.sharedInstance()


        if studentRepo.dataIsGood == true {
            self.studentLocation = studentRepo.studentsLocations
            self.tableView.reloadData()
        }
        else {
            renewStudents()
        }
    }
    func renewStudents() {
        StudentRepository.sharedInstance().populateStudents {(success, data, error) in
            if (success) {
                Shared.performUIUpdatesOnMain(){
                    self.studentLocation = data!
                    self.tableView.reloadData()
                }
            }
            else {
                Shared.displayErrorAsString(self, errorString: error)
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocation.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell") as! CustomListView
        
        let student = studentLocation[indexPath.row]
        
        cell.studentTextLabel.text = student.fullName
        cell.detailsLabel.text = student.mediaURL
        
        return cell
    }
    
    func validUrlChk (URLinput: String?) -> Bool {
        if URLinput != nil {
            if let URLinput = NSURL(string: URLinput!) {
                return UIApplication.sharedApplication().canOpenURL(URLinput)
            }
        }
        return false
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
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student =  studentLocation[indexPath.row]
        let app = UIApplication.sharedApplication()
        let url = student.mediaURL!
        
        if (validUrlChk (url) == false) {
            print("not a valid URL link")
        }
        else {
            app.openURL(NSURL(string: url)!)
        }
    }
        

    
}