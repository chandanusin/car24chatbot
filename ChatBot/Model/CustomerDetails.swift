//
//  BuyerDetails.swift
//  Chat Bot
//
//  Created by Adarsh on 05/01/19.
//  Copyright © 2019 Pallav Trivedi. All rights reserved.
//

import Foundation

class CustomerDetails: NSObject {

    var name:String?
    var location:String?
    var vehicleModel:String?
    var ownership:String?
    var targetPrice:Int?
    var kilometres:Int?
    var carType:String?
    var engineType:engineType? = nil
    var yearOfManufacture:Int = 0
    var brand: String?
    
    override init() {
        super.init()
    }
    
}


