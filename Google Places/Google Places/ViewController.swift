//
//  ViewController.swift
//  Google Places
//
//  Created by Ben Wernsman on 10/18/16.
//  Copyright © 2016 benw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get data when the internet when the view loads
        NetworkManager.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

