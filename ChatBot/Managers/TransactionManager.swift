//
//  TransactionManager.swift
//  Chat Bot
//
//  Created by Adarsh on 05/01/19.
//  Copyright © 2019 Pallav Trivedi. All rights reserved.
//

import Foundation


class TransactionManager: NSObject {
    
    static let sharedInstance: TransactionManager = {
        let instance = TransactionManager()
        // setup code
        return instance
    }()
    
    

}
