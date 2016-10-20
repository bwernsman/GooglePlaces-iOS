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
        NetworkManager.getData({ (response) in
            
            let status:[Bool] = response.status
            let address:[String] = response.address
            let name:[String] = response.name
            
            for i in 0 ..< name.count{
                print(address[i])
                print(name[i])
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

