//
//  ViewController.swift
//  Google Places
//
//  Created by Ben Wernsman on 10/18/16.
//  Copyright © 2016 benw. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate  {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var TableView: UITableView!
    var searchController = UISearchController()
    var locationManager: CLLocationManager!
    
    var gyms:[(name:String, gymId:String, location:String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load our API key from the JSON file
        Config().getConfig()
        
        //Setup search bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        TableView.tableHeaderView = searchController.searchBar
        
        //Setup tableview
        TableView.delegate = self
        TableView.dataSource = self
        TableView.alpha = 0.0
        TableView.rowHeight = 60.0
        
        //Start activity indicator when we are waiting for the gyms to load
        activityIndicator.startAnimating()
        
        //Setup Location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        // If location services are enabled
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse){
            locationManager.startUpdatingLocation()
        }
        else{
            //But we can load gyms not using location
            //The gyms might just not be near them
            showAlert("Alert",message: "Location is not activated, gyms will still appear but we can't give you results near you :(")
            loadGyms()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = gyms[indexPath.row].name
        cell.detailTextLabel?.text = gyms[indexPath.row].location
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(gyms[indexPath.row].gymId)
        //navigationController?.popViewControllerAnimated(false)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gyms.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func locationManager(locationManager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        storageModel.userLocation.found = true
        storageModel.userLocation.long = String(locationValue.longitude)
        storageModel.userLocation.lat = String(locationValue.latitude)
        
        //Stop getting the users location once we have it, no need to check multiple times
        locationManager.stopUpdatingLocation()
        
        //Load the gyms now that we have the users location
        loadGyms()
    }
    
    //Called if there is an error getting the users location
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        showAlert("Alert",message: "Error getting location, showing gyms in the US :(")
        loadGyms()
    }
    
    func loadGyms(){
        //Get data when we get the users location
        NetworkManager.getData("", callback: { (response) in
            if(response.status){
                self.gyms = response.gyms
                //Stop activity indicator and show tableview
                self.activityIndicator.stopAnimating()
                self.TableView.alpha = 1.0
                //Reload table because we have new data now
                self.TableView.reloadData()
            }
            else{
                print("An error occured")
            }
        })
    }
    
    //Update the list based on what the user types in
    //If the user runs out of gyms, we load more gyms in via the Google API
    func searchElements(input:String){
        gyms = gyms.filter {
            $0.name.lowercaseString.rangeOfString(input.lowercaseString) != nil
        }
        
        if(gyms.count != 0){
            self.TableView.reloadData()
        }
        else{
            //Encode the URL becuase a " " (space) will crash the application
            let encodedURL:String = input.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            //Get data when the user starts typing
            NetworkManager.getData(encodedURL, callback: { (response) in
                if(response.status){
                    self.gyms = response.gyms
                    self.TableView.reloadData()
                }
            })
        }
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Show alert
    func showAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        //Only update gyms if the user started typing
        if(searchController.searchBar.text! != ""){
            searchElements(String(searchController.searchBar.text!))
        }
        
    }
}

