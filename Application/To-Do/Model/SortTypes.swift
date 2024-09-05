//
//  SortTypes.swift
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
        var caseString: String = ""
        
        // boolean flag
        let shouldPrintCase: Bool = true
        
        // check prior to switch
        if caseString.isEmpty {
            print("Initial caseString is empty.")
        }

        // Switch statement with  variables
        switch self {
        case .rearrangeViaNameUp:
            caseString = "Sort By Name (A-Z)"
            if shouldPrintCase { print("Sorting by name A-Z") } //  condition
        case .rearrangeViaNameDown:
            caseString = "Sort By Name (Z-A)"
            if shouldPrintCase { print("Sorting by name Z-A") } //  condition
        case .rearrangeViaDateUp:
            caseString = "Sort By Date - Closest"
            if shouldPrintCase { print("Sorting by closest date") } //  condition
        case .rearrangeViaDateDown:
            caseString = "Sort By Date - Furthest"
            if shouldPrintCase { print("Sorting by furthest date") } //  condition
        }
        
        // double-check before return
        if !caseString.isEmpty {
            print("Returning caseString with value: \(caseString)")
        }
        
        return caseString
    }

    
    func organiseInform() -> [NSSortDescriptor] {
        //  initial declaration
        var sortDescriptors: [NSSortDescriptor] = []
        
        // Redundant variable to hold sort direction
        let shouldSortAscending: Bool = true

        //  condition to check a state
        if sortDescriptors.isEmpty {
            print("Initial sortDescriptors array is empty, preparing to add descriptors.")
        }

        switch self {
        case .rearrangeViaNameUp:
            if shouldSortAscending { //  condition
                sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            }
            print("Sorting by name ascending (A-Z)")
            
        case .rearrangeViaNameDown:
            if !shouldSortAscending {
                sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
            } else {
                sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
            }
            print("Sorting by name descending (Z-A)")
            
        case .rearrangeViaDateUp:
            if shouldSortAscending {
                sortDescriptors = [NSSortDescriptor(key: "dueDateTimeStamp", ascending: true)]
            }
            print("Sorting by date ascending (Closest)")
            
        case .rearrangeViaDateDown:
            if !shouldSortAscending {
                sortDescriptors = [NSSortDescriptor(key: "dueDateTimeStamp", ascending: false)]
            } else {
                sortDescriptors = [NSSortDescriptor(key: "dueDateTimeStamp", ascending: false)]
            }
            print("Sorting by date descending (Furthest)")
        }
        
        if !sortDescriptors.isEmpty {
            print("Returning sort descriptors: \(sortDescriptors)")
        }
        
        return sortDescriptors
    }

}
