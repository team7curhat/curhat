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
    
    let logPrompts: [(user: String, modelResponse: String)]
    
    @State private var summaryText: String = "ini summary"
    @State private var shouldNavigate = false
    @State private var progress: CGFloat = 0.0 // For loading bar progress
    @AppStorage("userNickname") private var nickname: String = ""
    var body: some View {
            ZStack{
                Color("primary-10")
                    .ignoresSafeArea(.all)
                   
                VStack(alignment:.center, spacing: 20) {
                    Text("Thank you for sharing your story with me!")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 50).foregroundStyle(.white) .multilineTextAlignment(.center)
                    
                    
                    Image("loading-char").resizable().scaledToFit().frame(width: 250, height: 150)
                        .padding(.top, 28)
                    
                    // Progress bar implementation
                    ZStack(alignment: .leading) {
                        // Background of loading bar
                        Capsule()
                            .fill(Color(.white)) // Slightly lighter than background
                            .frame(height: 20)
                        
                        // Foreground/filled portion
                        Capsule()
                            .fill(Color("primary-8")) // White filled part
                            .frame(width: UIScreen.main.bounds.width * 0.7 * progress, height: 20)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.7) // Make the bar 70% of screen width
                    .padding(.horizontal, 30)
              
                }
                .navigationBarBackButtonHidden(true) // Hide default back button
                .background(
                    NavigationLink(
                        destination: SummaryView(summary: summaryText, logPrompts: logPrompts ).navigationBarBackButtonHidden(true),      // Go to SummaryView
                        isActive: $shouldNavigate,
                        label: { EmptyView() }
                    )
                    .hidden()
                )
                .onAppear {
                    
                    shouldNavigate = false
                    // Start loading animation when view appears
                    startLoadingAnimation()
                    
                    // Trigger summary function when view appears
                    summary()
                }
            }
            
      
    }
    
    func startLoadingAnimation() {
        // Reset progress to ensure animation starts from beginning
        progress = 0.0
        
        // Animate loading bar to 90% over 2 seconds
        withAnimation(.linear(duration: 2.0)) {
            progress = 0.8
        }
    }
    
    func summary() {
        let summaryPrompt = """
        
        User name: \(nickname) 
         Model name (confidant): Mochi  

                The following is the user's full story log:
                \(logPrompts)
        
        Your assignment:  
                Write a short **summary** of the user story above. Use a casual and understandable language style for young people aged 18-25.

                Don't be too stiff or formal - you're Mochi, the confidante who makes people feel like they're being looked after.

                Finally, add **words of encouragement** at the end of the summary, which are relevant and appropriate to the content of the user story.  
                Don't overdo it, but keep it warm and touching.
        """
        
        Task {
            do {
                let result = try await model.generateContent(summaryPrompt)
                summaryText = result.text ?? ""

                // Complete the loading animation and then navigate
                withAnimation(.easeOut(duration: 0.5)) {
                    progress = 1.0
                }
                
                // Add delay of 2 seconds before navigating
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    shouldNavigate = true
                }
                
            } catch {
                summaryText = "Sorry moci can't make a summary at the moment. try again in a while :)"
                print(error)
                
                // Complete loading bar even with error
                withAnimation(.easeOut(duration: 0.5)) {
                    progress = 1.0
                }
                
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
