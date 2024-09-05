//
//  Extensions.swift
//
//  Created by Mazari Bahaduri on 25/06/2024.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import Foundation

extension String {
    
    // Static constant for an empty string
    static let empty = ""
    
    // Method to trim whitespace and newlines from the string
    func trimSpacesAndNewlines() -> String {
        //  intermediate variable
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        print("Trimmed string: '\(trimmed)'")  // Debug statement for clarity
        return trimmed
    }
    
    //  method to demonstrate nf code
    func debugPrintLength() -> Int {
        let length = self.count
        print("The length of the string is: \(length)")
        return length
    }
}

