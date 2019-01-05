//
//  NetworkManager.swift
//  Chat Bot
//
//  Created by Adarsh on 05/01/19.
//  Copyright © 2019 Pallav Trivedi. All rights reserved.
//

import Foundation

class NetworkManager: NSObject {
    
    static let sharedInstance: NetworkManager = {
        let instance = NetworkManager()
        // setup code
        return instance
    }()
    let defaultSession = URLSession(configuration: .default)
    // 2
    var dataTask: URLSessionDataTask?
    
    
    func getListOfCarAvailableWithDetails(withBuyerDetails: BuyerDetails, completion : @escaping (_ result: [ListedCarDetails], _ error: Error?) -> Void ) {
        // 1
        dataTask?.cancel()
        // 2
        if var urlComponents = URLComponents(string: "http://10.2.41.83/buy.php") {
            
            var query = ""
            if let name = withBuyerDetails.name {
              
               query =  "ownerName=\(name)&"
            }
            if let  detail = withBuyerDetails.location  {
               query = query + "location=\(detail)&"
            }
            if let detail = withBuyerDetails.vehicleModel {
               query = query + "model=\(detail)&"
            }
            if let detail = withBuyerDetails.brand {
               query = query + "brand=\(detail)&"
            }
            if let detail = withBuyerDetails.ownership {
               query = query + "ownership=\(detail)&"
            }
            if let detail = withBuyerDetails.targetPrice {
               query = query + "price=\(detail)&"
            }
            if let detail =  withBuyerDetails.kilometres {
                query = query + "kmsDriven=\(detail)&"
            }
            if let detail = withBuyerDetails.engineType {
                query = query + "engineType=\(detail.rawValue)&"
            }
            if let detail =   withBuyerDetails.carType {
                query = query + "carType=\(detail)&"
            }
            if withBuyerDetails.yearOfManufacture != 0 {
               query = query + "yearOfManufacture=\( withBuyerDetails.yearOfManufacture)&"
            }
            query.removeLast()
            urlComponents.query = query
            // 3
            guard let url = urlComponents.url else { return }
            // 4
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                // 5
                if let error = error {
                    DispatchQueue.main.async {
                        completion([ListedCarDetails](), error)
                    }
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    let resultList =  self.updateSearchResults(data)
                    // 6
                    DispatchQueue.main.async {
                        completion(resultList, nil)
                    }
                }
            }
            // 7
            dataTask?.resume()
        }
    }

    
    fileprivate func updateSearchResults(_ data: Data) -> [ListedCarDetails]{
        var response: [AnyObject]?
        
        var listCarDetails: [ListedCarDetails] =   [ListedCarDetails]()
       
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
        } catch let parseError as NSError {
            
            return listCarDetails
        }
        
        guard let array = response as? [AnyObject] else {
           
            return listCarDetails
        }
        for carInfoDi in array {
           let carInfoDict = carInfoDi as! [String:AnyObject]
           let ownerName = carInfoDict["ownerName"] as! String
           let brand = carInfoDict["brand"] as! String
           let model = carInfoDict["model"] as! String
           let location = carInfoDict["location"] as! String
            let ownership = carInfoDict["ownership"] as! String
            let price = Int(carInfoDict["price"] as! String)!
            let kmsDriven = Int(carInfoDict["kmsDriven"] as! String)!
            let carType = carInfoDict["carType"] as! String
            let eType = engineType (rawValue: Int (carInfoDict["engineType"] as! String )!)!
            let image = carInfoDict["image"] as! String
            let yearOfManufacture = carInfoDict["yearOfManufacture"] as! String
            
            let pincode =  Int(carInfoDict["pincode"] as! String)!
            
            let addId = carInfoDict["addId"] as! String
            
           let listedCarDetails = ListedCarDetails()
            listedCarDetails.ownerName = ownerName
             listedCarDetails.brand = brand
             listedCarDetails.model = model
             listedCarDetails.location = location
             listedCarDetails.ownership = ownership
             listedCarDetails.price = price
             listedCarDetails.kmsDrive = kmsDriven
             listedCarDetails.carType = carType
             listedCarDetails.engineType = eType
             listedCarDetails.image = image
             listedCarDetails.yearOfManufacture = yearOfManufacture
            listedCarDetails.addId = addId
             listedCarDetails.addId = addId
            listedCarDetails.pincode = pincode
            listCarDetails.append(listedCarDetails)
           

        }
        
       return listCarDetails
    }
}
