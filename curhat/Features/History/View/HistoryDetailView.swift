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
                    
                    Text("Kamu kemarin cerita kalau")
                        .multilineTextAlignment(.leading)
                        .frame(width: 130, height: 100)
                        .offset(x: -100, y: -280)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("primary-9"))
                        .font(.body)
                    
                    ScrollView{
                        Text(summary.summaryText)
                            .font(.body)
                           
                    }
                    .frame(maxHeight: 400)
                    .padding(.top, 150)
                    .padding(.horizontal, 50)
                    
                }
                
               

                Divider()

              
                
                HStack{
                    Image("ai-respon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height:54)
                    ScrollView {
                        Text("Apa yang sedang kamu rasakan sekarang")
                            .font(.headline)
                            .foregroundColor(Color("primary-6"))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    // 3. Constrain to at most 5 lines tall:
                    .frame(maxHeight: 100)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("primary-1"))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("primary-3"), lineWidth: 1)
                    )
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                  
                }

                ForEach(summary.logPrompts, id: \.self) { log in
                    VStack(alignment: .leading, spacing: 8) {
                       
                        
                        HStack{
                           
                            ScrollView {
                                Text("\(log.userText)")
                                    .font(.headline)
                                    .foregroundColor(Color("primary-6"))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            // 3. Constrain to at most 5 lines tall:
                            .frame(maxHeight: 100)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("primary-1"))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("primary-3"), lineWidth: 1)
                            )
                            .padding(.horizontal, 16)
                            .padding(.vertical, 4)
                            
                            Image("user-respon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44, height:54)
                          
                        }
                        
                        HStack{
                            Image("ai-respon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44, height:54)
                            ScrollView {
                                Text("\(log.modelResponse)")
                                    .font(.headline)
                                    .foregroundColor(Color("primary-6"))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            // 3. Constrain to at most 5 lines tall:
                            .frame(maxHeight: 100)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("primary-1"))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("primary-3"), lineWidth: 1)
                            )
                            .padding(.horizontal, 16)
                            .padding(.vertical, 4)
                          
                        }
                    }
                }
            }
           
        }
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

