//
//  Storage.swift
//  Google Places
//
//  Created by Ben Wernsman on 11/8/16.
//  Copyright © 2016 benw. All rights reserved.
//

import Foundation


class Storage{
    var apiKey:String = ""
    var gyms:[(name:String, gymId:String, location:String)] = []
    var userLocation:(found:Bool, lat:String, long:String) = (found: false, lat:"", long:"")
}

var storageModel = Storage()