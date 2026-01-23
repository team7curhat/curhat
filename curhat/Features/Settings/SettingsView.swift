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
        
        ZStack(alignment: .topLeading){
            Color("primary-1")
                .ignoresSafeArea(edges: .all)
            
            VStack(alignment:.leading){
                
                NavigationLink("Change username") {
                    ChangeUsernameView().navigationBarBackButtonHidden(true)
                    
                        
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.white)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    .cornerRadius(8)
                
                Button("Delete account", role: .destructive) {
                    showDeleteAlert = true
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.red)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .cornerRadius(8)
            }
            .padding( 20)
        }.alert(
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
    }
}

#Preview {
    SettingsView()
}
