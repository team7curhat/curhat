//
//  LoadingSummaryView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 07/05/25.
//

import SwiftUI
import GoogleGenerativeAI
import Lottie

struct LoadingSummaryView: View {
    let model = GeminiModel.shared.generativeModel
    
    @Binding var rootIsActive : Bool
    
    let logPrompts: [String]
    
    @State private var summaryText: String = "ini summary"
    @State private var shouldNavigate = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment:.center, spacing: 20) {
                LottieView(animation: .named("LoadingSummary"))
                    .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                    .animationSpeed(1.2)
                    .frame(width: 80, height: 80)       // fixed size so layout never changes
                
                Text("Hidup emang kadang-kadang kidding. Tapi makasih ya kamu udah mau cerita sama aku! Aku tau kamu kuat! ❤️")
                    .padding(.horizontal, 50)
                
            }
            .navigationBarBackButtonHidden(true) // Hide default back button
            .background(
                NavigationLink(
                    destination: SummaryView(shouldPopToRootView: self.$rootIsActive, summary: summaryText ),      // Go to SummaryView
                    isActive: $shouldNavigate,
                    label: { EmptyView() }
                )
                .isDetailLink(false)
                .hidden()
            )
            .onAppear {
                // Trigger summary function when view appears
                summary()
            }
        }
    }
    
    func summary() {
        let summaryPrompt = """
        buatlah summary dari log cerita berikut
        Berikut log cerita user:
        \(logPrompts)
        
        dan tambahkan kata penyemangat diakhir berdasarkan ceritanya
        """
        
        Task {
            do {
                print("masuk")
                let result = try await model.generateContent(summaryPrompt)
                summaryText  = result.text ?? ""
                
                print("Hasil: \(summaryText)")
                
                // Add delay of 2 seconds before navigating
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    shouldNavigate = true
                }
                
            } catch {
                summaryText = "Error: \(error.localizedDescription)"
                print(error)
                
                // Add delay of 2 seconds before navigating even on error
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    shouldNavigate = true
                }
            }
        }
    }
}

#Preview {
    
    LoadingSummaryView(rootIsActive: .constant(true), logPrompts: [])
}
