//
//  Extensions.swift
//
//  Created by Mazari Bahaduri on 25/06/2024.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import Foundation

extension String {
    
    static let empty = ""
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
