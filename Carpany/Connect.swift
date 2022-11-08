//
//  Connect.swift
//  Carpany
//
//  Created by CYH on 11/7/22.
//

import Foundation
import Parse





class Server {
    
    
    
    
    
    let customQueue = DispatchQueue(label: "Custom")
    
    
    func fetchCar(_ searchedText: String, completion: @escaping ([String]) -> Void) {
        
        customQueue.async {
            Thread.sleep(forTimeInterval: 5)
            let results = MockData.displayableCars.filter{
                car in car.starts(with: searchedText)
            }
            
            completion(results)
        }
    }
}
