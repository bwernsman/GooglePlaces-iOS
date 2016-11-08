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
    
    var useLocation:Bool = false
    
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
            print("Tell user that they need to activate location if they want better results")
            //But we can load gyms not using location
            //The gyms might just not be near them
            loadGyms()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = storageModel.gyms[indexPath.row].name
        cell.detailTextLabel?.text = storageModel.gyms[indexPath.row].location
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(storageModel.gyms[indexPath.row].gymId)
        //navigationController?.popViewControllerAnimated(false)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storageModel.gyms.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func locationManager(locationManager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        storageModel.userLocation.found = true
        storageModel.userLocation.long = String(locationValue.longitude)
        storageModel.userLocation.lat = String(locationValue.latitude)
        
        print(storageModel.userLocation.long)
        print(storageModel.userLocation.lat)
        
        //Stop getting the users location once we have it, no need to check multiple times
        locationManager.stopUpdatingLocation()
        
        //Load the gyms now that we have the users location
        loadGyms()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("An error occurred getting location")
    }
    
    func loadGyms(){
        //Get data when we get the users location
        NetworkManager.getData("", callback: { (response) in
            if(response.boolValue){
                //Stop activity indicator and show tableview
                self.activityIndicator.stopAnimating()
                self.TableView.alpha = 1.0
                //Reload table because we have new data now
                self.TableView.reloadData()
            }
        })
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        //Only update gyms if the user started typing
        if(searchController.searchBar.text! != ""){
            //Encode the URL becuase a " " (space) will crash the application
            let encodedURL:String = searchController.searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            //Get data when the user starts typing
            NetworkManager.getData(encodedURL, callback: { (response) in
                if(response.boolValue){
                    self.TableView.reloadData()
                }
            })
        }
        
    }
}

