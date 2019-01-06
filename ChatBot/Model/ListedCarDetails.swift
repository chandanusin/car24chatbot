//
//  ListedCarDetails.swift
//  Chat Bot
//
//  Created by Adarsh on 05/01/19.
//  Copyright © 2019 Pallav Trivedi. All rights reserved.
//

import Foundation

class ListedCarDetails: NSObject {
    
    var ownerName:String = ""
    var brand:String = ""
    var model : String = ""
    var vehicleModel:String = ""
    var location:String = ""
    var ownership:String = ""
    var price:Int = 0
    
    var carType:String = ""
    
    var engineType: engineType = .engineTypePetrol
    
    var kmsDrive: Int = 0
    
    var addId: String = ""
    
    var yearOfManufacture: String = ""
    
    var image: String = ""
    
    var pincode: Int = 0
    
    override init() {
        super.init()
    }
    
    
    
    
}


