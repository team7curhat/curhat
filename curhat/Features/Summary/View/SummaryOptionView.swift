//
//  SummaryOptionView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 16/05/25.
//

import SwiftUI
import SwiftData


struct SummaryOptionView: View {
    let summary: String
    let logPrompts: [(user: String, modelResponse: String)]
    @ObservedObject var navigationManager = NavigationManager.shared
    @Environment(\.modelContext) private var modelContext
    @State private var navigateToStory = false
    @State private var navigateToHome = false
    
    var body: some View {
        VStack(alignment: .center, spacing:36) {
            Text("How do you feel now?")
                .foregroundStyle(Color("primary-6"))
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top,75)
                .frame(width: 250, height: 180)
            HStack(alignment: .center, spacing:36) {
                
                
                // ✅ Custom button + navigasi manual
                Button(action: {
                    // Simpan data
                    let logPromptModels = logPrompts.map {
                        LogPrompt(userText: $0.user, modelResponse: $0.modelResponse)
                    }
                    let newSummary = SummaryRecord(summaryText: summary, logPrompts: logPromptModels)
                    modelContext.insert(newSummary)
                    
                    
                    navigationManager.setStoryActive(setStoryActive: false)
                    print(navigationManager.hasStoryActive)
                    
                }) {
                    VStack {
                        Image("summary-cerita-lagi")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                        Text("I'd like to tell more")
                            .foregroundStyle(Color("primary-6"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                }
                
                
              
                Button(action: {
                    // Simpan data
                    let logPromptModels = logPrompts.map {
                        LogPrompt(userText: $0.user, modelResponse: $0.modelResponse)
                    }
                    let newSummary = SummaryRecord(summaryText: summary, logPrompts: logPromptModels)
                    modelContext.insert(newSummary)
                    
                    // Pindah ke HomeView
//                    navigateToHome = true
                    
                    navigationManager.setHomeActive(setHomeActive: false)
                    
                    
                }) {
                    VStack {
                        Image("summary-lega")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                        Text("I feel better")
                            .foregroundStyle(Color("primary-6"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                }
                
                
            }
            Image("bg-summary")
                .resizable()
                .scaledToFit()
                .padding(.top, 100)
                .id("_bottom")
            
            // Navigation trigger
//            NavigationLink(
//                destination: StoryView(emotionName: "senang")
//                    .navigationBarBackButtonHidden(true),
//                isActive: $navigateToStory,
//                label: { EmptyView() }
//            )
//            
//            NavigationLink(
//                destination: HomeView()
//                    .navigationBarBackButtonHidden(true),
//                isActive: $navigateToHome,
//                label: { EmptyView() }
//            )
        }
    }
}

#Preview {
    SummaryOptionView(summary: "Lorem ipsum dolor sit amet consectetur. Imperdiet donec ullamcorper purus diam pharetra tortor. Ultrices tincidunt pulvinar morbi tempor. Ultricies aenean et facilisi pellentesque odio orci. Quam velit non amet amet phasellus at eu lectus quam. Senectus tristique scelerisque in sagittis aliquam. Gravida rhoncus quam viverra porttitor donec aliquet. Elementum aliquet ut donec turpis malesuada dictum. Nunc ac proin dolor purus enim. Nunc amet volutpat phasellus ornare velit enim nec.Lorem ipsum dolor sit amet consectetur. Imperdiet donec ullamcorper purus diam pharetra tortor. Ultrices tincidunt pulvinar morbi tempor. Ultricies aenean et facilisi pellentesque odio orci. Quam velit non amet amet phasellus at eu lectus quam. Senectus tristique scelerisque in sagittis aliquam. Gravida rhoncus quam viverra porttitor donec aliquet. Elementum aliquet ut donec turpis malesuada dictum. Nunc ac proin dolor purus enim. Nunc amet volutpat phasellus ornare velit enim nec.", logPrompts: [])
}
