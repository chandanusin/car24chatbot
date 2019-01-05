//
//  BuyerDetails.swift
//  Chat Bot
//
//  Created by Adarsh on 05/01/19.
//  Copyright © 2019 Pallav Trivedi. All rights reserved.
//

import Foundation

class SellerDetails: CustomerDetails {
    
    var addId = UUID().uuidString
    var extra4 = ""
    var extra5 = ""
    var pincode = 0
    var image = "test.url"
    override init() {
        super.init()
    }
}


