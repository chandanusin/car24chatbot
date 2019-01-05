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
    
    func getListOfCarDetailsWithBuyerDetails(details: BuyerDetails,  completion : @ escaping (_ result: [ListedCarDetails], _ error: Error?) -> Void) {
        
        NetworkManager.sharedInstance.getListOfCarAvailableWithDetails(withBuyerDetails: details, completion: completion);
    }
    
    func postSellerDetails(details: SellerDetails,  completion : @ escaping (_ error: Error?) -> Void) {
        
        NetworkManager.sharedInstance.postSellerDetails(witDetails: details, completion: completion);
    }
    
    

}
