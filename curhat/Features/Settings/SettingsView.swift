//
//  SettingsView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 16/05/25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("userNickname") private var nickname: String = ""
    @Environment(\.modelContext) private var modelContext
    
    @Query private var summaries: [SummaryRecord]
    
    @State private var showDeleteAlert = false
    @State private var navigateToOnboarding1 = false
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
            List {
                NavigationLink("Change username") {
                    onboarding3().navigationBarBackButtonHidden(true)
                }
                
                Button("Delete account", role: .destructive) {
                    showDeleteAlert = true
                }
            }
            .navigationTitle("Settings")
            // Hidden nav link for post-delete navigation
           
            .alert(
                "Are you sure you want to delete your account and all history?",
                isPresented: $showDeleteAlert
            ) {
                Button("Delete", role: .destructive) {
                    deleteAccount()
                }
                Button("Cancel", role: .cancel) { }
            }
    }
    
    private func deleteAccount() {
        // 1) Clear stored nickname
        nickname = ""
        
        // 2) Delete all summary records
        for record in summaries {
            modelContext.delete(record)
        }
        
        // 3) Trigger navigation to onboarding1
        navigateToOnboarding1 = true
        
        dismiss()
        
        // If you're using manual save:
        // try? modelContext.save()
    }
}

#Preview {
    SettingsView()
}
