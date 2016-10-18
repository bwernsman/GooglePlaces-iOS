//
//  NetworkManagerModel.swift
//  Google Places
//
//  Created by Ben Wernsman on 10/18/16.
//  Copyright © 2016 benw. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManagerModel: NSObject {
    let baseURL:String = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=gregory%20gym%20ut&type=gym&key=AIzaSyD_6C0Xh22Z-eqDOiXwMz1qzXYgjY_ShGk"

    func getData() {
        var json:JSON = nil
        Alamofire.request(.GET, baseURL,encoding: .JSON).responseJSON {response in
            if(response.result.error != nil){
                print("Network Error")
            }
            else{
                json = JSON(data: response.data!)
                if(json == nil){
                    print("Parse Error")
                }
                else{
                    //Check if the name and address exist
                    if(json["results"][0]["formatted_address"].exists() && json["results"][0]["name"].exists()){
                        let address:String = json["results"][0]["formatted_address"].string!
                        let name:String = json["results"][0]["name"].string!
                        
                        //Print values
                        print(address)
                        print(name)
                    }
                }
            }
        }
    }

}

var NetworkManager = NetworkManagerModel()