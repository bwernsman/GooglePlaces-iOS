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
    
    func getData(userInput:String, callback: (status:Bool) -> ()) {
        
        storageModel.gyms = []
        var json:JSON = nil
        var baseURL:String = ""
        
        if(storageModel.userLocation.found){
            //If they have location enabled
            baseURL = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=" + userInput + "&location=" + storageModel.userLocation.lat + "," +  storageModel.userLocation.long + "&radius=24140&type=gym&key=" + storageModel.apiKey
        }
        else{
            //If location is not enabled
            baseURL = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=" + userInput + "&type=gym&key=" + storageModel.apiKey
        }
        
        Alamofire.request(.GET, baseURL,encoding: .JSON).responseJSON {response in
            if(response.result.error != nil){
                print("Network Error")
                return callback(status: false)
            }
            else{
                json = JSON(data: response.data!)
                if(json == nil){
                    print("Parse Error")
                    return callback(status: false)
                }
                else{
                    let count:Int = (json["results"].array?.count)!
                    
                    if(count == 0){
                        print("No places found!!")
                        return callback(status: false)
                    }
                    else{
                        for i in 0 ..< count {
                            if(json["results"][i]["formatted_address"].exists() && json["results"][i]["name"].exists() && json["results"][i]["id"].exists()){
                                
                                let gymName:String = json["results"][i]["name"].string!
                                let gymAddress:String = json["results"][i]["formatted_address"].string!
                                let gymId:String = json["results"][i]["id"].string!
                                
                                storageModel.gyms.append((name: gymName, gymId: gymId, location: gymAddress))
                            }
                        }
                        
                    }
                    return callback(status: true)
                }
            }
        }
    }
}

var NetworkManager = NetworkManagerModel()