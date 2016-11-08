//
//  ViewController.swift
//  Google Places
//
//  Created by Ben Wernsman on 10/18/16.
//  Copyright © 2016 benw. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet var TableView: UITableView!
    var searchController = UISearchController()
    
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

        //Get data when the internet when the view loads
        NetworkManager.getData("", callback: { (response) in
            if(response.boolValue){
                self.TableView.reloadData()
            }
        })
 
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

    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        //Encode the URL becuase a " " (space) will crash the application
        let encodedURL:String = searchController.searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        NetworkManager.getData(encodedURL, callback: { (response) in
            if(response.boolValue){
                self.TableView.reloadData()
            }
        })
    }
}

