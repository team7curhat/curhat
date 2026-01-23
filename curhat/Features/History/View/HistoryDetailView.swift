//
//  HistoryDetailView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 16/05/25.
//
import SwiftUI
import SwiftData

// Import the file containing the SummaryRecord definition

struct HistoryDetailView: View {
    let summary: SummaryRecord
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 24) {
                
                ZStack(alignment: .center){
                    Image("history-summary")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 725)
                    
                    Text("You told me that")
                        .multilineTextAlignment(.leading)
                        .frame(width: 130, height: 100)
                        .offset(x: -100, y: -280)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("primary-9"))
                        .font(.body)
                    
                    ScrollView{
                        Text(summary.summaryText)
                            .font(.body)
                            .foregroundStyle(.black)
                           
                    }
                    .frame(maxHeight: 360)
                    .padding(.top, 80)
                    .padding(.horizontal, 50)
                    
                }
                
               

                Divider()

              
              
            }
           
        }
        .background(Color("primary-1"))
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading){
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color("primary-6"))
                        .font(.system(size: 17, weight: .semibold))
                }
            }
        }
    }
}

#Preview {
    // Create instances of the actual SummaryRecord and LogPrompt models for the preview
    let logs = [
        LogPrompt(userText: "Halo, apa kabar?", modelResponse: "Saya baik, ada yang bisa dibantu?"),
        LogPrompt(userText: "Saya ingin cerita tentang hari saya.", modelResponse: "Tentu, silakan cerita.")
    ]
    
    let previewSummary = SummaryRecord(
        summaryText: "Ini adalah ringkasan cerita contoh untuk preview.",
        logPrompts: logs
    )
    
    // Use the actual summary instance in the preview
    HistoryDetailView(summary: previewSummary)
}

