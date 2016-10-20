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
    let baseURL:String = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=24%20fitness&type=gym&key=AIzaSyD_6C0Xh22Z-eqDOiXwMz1qzXYgjY_ShGk"

    func getData(callback: (status:[Bool], address:[String], name:[String]) -> ()) {
        var json:JSON = nil
        var status:[Bool]  = []
        var address:[String]  = []
        var name:[String]  = []
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
                    
                    let count:Int = (json["results"].array?.count)!
                    
                    if(count == 0){
                        print("No places found!!")
                    }
                    else{
                        for i in 0 ..< count {
                            //Check if the name and address exist
                            if(json["results"][i]["formatted_address"].exists() && json["results"][i]["name"].exists()){
                                let addressName:String = json["results"][i]["formatted_address"].string!
                                let nameName:String = json["results"][i]["name"].string!
                                
                                print(address)
                                print(name)
                                
                                status.append(true)
                                address.append(addressName)
                                name.append(nameName)
                            
                            }
                        }
                        
                    }
                    
                    return callback(status: status, address: address, name: name)
                }
            }
            return callback(status: [false], address: [""], name: [""])
        }
    }

}

var NetworkManager = NetworkManagerModel()