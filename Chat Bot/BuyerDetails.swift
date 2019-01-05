//
//  BuyerDetails.swift
//  Chat Bot
//
//  Created by Adarsh on 05/01/19.
//  Copyright © 2019 Pallav Trivedi. All rights reserved.
//

import Foundation

class BuyerDetails: NSObject {

    var name:String?
    var location:String?
    var vehicleModel:String?
    var ownership:String?
    var targetPrice:Float?
    var kilometres:Float?
    var carType:String?
    var engineType:engineType = .engineTypePetrol
    
    override init() {
        super.init()
    }
    
    
}

