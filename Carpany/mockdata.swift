//
//  mockdata.swift
//  Carpany
//
//  Created by CYH on 11/6/22.
//

import Foundation
struct MockData{
    static let cars =
        ["Bentley", "Chevrolet", "Chrysler"]
    
    static var displayableCars:[String]{
        self.cars.sorted(by:{$0<$1})
    }
    
}



