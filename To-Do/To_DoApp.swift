//
//  To_DoApp.swift
//  To-Do
//
//  Created by Mazari Bahaduri on 16/08/2024.
//

import SwiftUI

@main
struct To_DoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
