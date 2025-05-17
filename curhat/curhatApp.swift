//
//  curhatApp.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 06/05/25.
// Test push Saki Pardano test

import SwiftUI
import SwiftData

@main
struct curhatApp: App {
    var body: some Scene {
        WindowGroup {
            
                HomeView().font(.system(.body, design: .rounded))
         
        }
        .modelContainer(for: [SummaryRecord.self, LogPrompt.self])
    }
}
