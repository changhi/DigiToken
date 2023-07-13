//
//  DigiTokenApp.swift
//  DigiToken
//
//  Created by Daniel Chang on 7/12/23.
//

import SwiftUI

@main
struct DigiTokenApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
