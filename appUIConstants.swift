//
//  appUIConstants.swift
//  Chat Bot
//
//  Created by Chandan verma on 05/01/19.
//  Copyright © 2019 Pallav Trivedi. All rights reserved.
//

import Foundation

enum engineType : Int {
    case engineTypePetrol   = 0
    case engineTypeDiesel
    case engineTypeElectric
    
    var engineTitle : String {
        get {
            switch(self) {
            case .engineTypePetrol:
                return "Petrol"
            case .engineTypeDiesel:
                return "Diesel"
            case .engineTypeElectric:
                return "Electric"
            }
        }
    }
}


