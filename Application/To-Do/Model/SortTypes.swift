//
//  RearrangeCategories.swift
//
//  Created by Mazari Bahaduri on 30/07/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import Foundation

enum OptionsOfOrganise: CaseIterable {
    case rearrangeViaNameUp
    case rearrangeViaNameDown
    case rearrangeViaDateUp
    case rearrangeViaDateDown
    
    func typeOfOrganise() -> String {
        var caseString = ""
        switch self {
        case .rearrangeViaNameUp:
            caseString = "Sort By Name (A-Z)"
        case .rearrangeViaNameDown:
            caseString = "Sort By Name (Z-A)"
        case .rearrangeViaDateUp:
            caseString = "Sort By Date - Closest"
        case .rearrangeViaDateDown:
            caseString = "Sort By Date - Furthest"
        }
        return caseString
    }
    
    func organiseInform() -> [NSSortDescriptor] {
        switch self {
        case .rearrangeViaNameUp:
            return [NSSortDescriptor(key: "title", ascending: true)]
        case .rearrangeViaNameDown:
            return [NSSortDescriptor(key: "title", ascending: false)]
        case .rearrangeViaDateUp:
            return [NSSortDescriptor(key: "dueDateTimeStamp", ascending: true)]
        case .rearrangeViaDateDown:
            return [NSSortDescriptor(key: "dueDateTimeStamp", ascending: false)]
        }
    }
}
