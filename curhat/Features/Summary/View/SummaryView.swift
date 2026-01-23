//
//  SummaryView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 06/05/25.
//

import SwiftUI
import Lottie
struct SummaryView: View {
    
    let summary: String
    let logPrompts: [(user: String, modelResponse: String)]
    @StateObject private var promptManager = PromptManager()
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var navigationManager = NavigationManager.shared
    @State private var navigateToHome = false
    @State private var showingConfirmationDialog: Bool = false
    
    var body: some View {
            ZStack(alignment: .top) {
                // Background that extends to all edges
                Color("primary-1")
                    .edgesIgnoringSafeArea(.all)
                
                HStack{
                    Spacer()
                    Button(action:{showingConfirmationDialog = true}){
                        Text("Exit")
                            .padding(.vertical,4)
                            .padding(.horizontal,12)
                            .background(Color(.white))
                            .fontWeight(.semibold)
                            .cornerRadius(4)
                    }
                }
                .padding(.top,10)
                .padding(.horizontal, 20)
                
//                ScrollViewReader { proxy in
//                    ScrollView {
                        VStack {
                            ZStack(alignment: .center) {
                                Image("summary-bg")
                                    .resizable()
                                    .scaledToFit()
                                
                                Text("From the stories I heard from you,")
                                    .multilineTextAlignment(.leading)
                                    .frame(width: 130, height: 100)
                                    .offset(x: -100, y: -280)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("primary-9"))
                                    .font(.body)
                                
                                ScrollView {
                                    Text("\(summary)").foregroundStyle(Color("primary-10")).fontWeight(.medium)
                                }
                                .frame(maxHeight: 400)
                                .padding(.top, 150)
                                .padding(.horizontal, 50)
                            }.padding(.horizontal, 12)
                            
//                            Button(action: {
//                                withAnimation {
//                                    proxy.scrollTo("_bottom", anchor: .bottom)
//                                }
//                            }){
//                                VStack(alignment: .center, spacing: 10) {
//                                    Text("Scroll down")
//                                        .foregroundStyle(Color("primary-6")).fontWeight(.medium)
//                                        .font(.caption)
//                                    Image(systemName: "chevron.down")
//                                        .foregroundStyle(Color("primary-7"))
//                                }
//                                .padding(.top, 16)
//                            }
                            
//                            SummaryOptionView(summary: summary, logPrompts: logPrompts)
                            
                            
                            
                            
                        }.padding(.top, 20)
                        
//                    }
//                }
            }
            .alert("Save summary?", isPresented: $showingConfirmationDialog) {
                    Button("Yes") {
                        // Perform the action here
                        let logPromptModels = logPrompts.map {
                            LogPrompt(userText: $0.user, modelResponse: $0.modelResponse)
                        }
                        let newSummary = SummaryRecord(summaryText: summary, logPrompts: logPromptModels)
                        modelContext.insert(newSummary)
                        
                        // Pindah ke HomeView
    //                    navigateToHome = true
                        
                        navigationManager.setHomeActive(setHomeActive: false)
                    }
                    Button("No", role: .cancel) {
                        // Dialog dismisses automatically
                        navigationManager.setHomeActive(setHomeActive: false)
                    }
                }
        
    }
}

#Preview {
    SummaryView(summary: "Lorem ipsum dolor sit amet consectetur. Imperdiet donec ullamcorper purus diam pharetra tortor. Ultrices tincidunt pulvinar morbi tempor. Ultricies aenean et facilisi pellentesque odio orci. Quam velit non amet amet phasellus at eu lectus quam. Senectus tristique scelerisque in sagittis aliquam. Gravida rhoncus quam viverra porttitor donec aliquet.", logPrompts: [] )
}
