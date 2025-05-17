//
//  SummaryView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 06/05/25.
//

import SwiftUI
import Lottie
struct SummaryView: View {
    @Binding var shouldPopToRootView : Bool
    let summary: String
    let logPrompts: [(user: String, modelResponse: String)]
    @StateObject private var promptManager = PromptManager()
    @Environment(\.modelContext) private var modelContext
    @State private var navigateToHome = false
    @State private var showingConfirmationDialog: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Background that extends to all edges
                Color("primary-1")
                    .edgesIgnoringSafeArea(.all)
                
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            ZStack(alignment: .center) {
                                Image("summary-bg")
                                    .resizable()
                                    .scaledToFit()
                                
                                Text("Dari cerita yang aku dengar darimu,")
                                    .multilineTextAlignment(.leading)
                                    .frame(width: 130, height: 100)
                                    .offset(x: -100, y: -280)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("primary-9"))
                                    .font(.body)
                                
                                ScrollView {
                                    Text("\(summary)").foregroundStyle(Color("primary-6")).fontWeight(.medium)
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
                            //                                    Text("Scroll ke bawah")
                            //                                        .foregroundStyle(Color("primary-6")).fontWeight(.medium)
                            //                                        .font(.caption)
                            //                                    Image(systemName: "chevron.down")
                            //                                        .foregroundStyle(Color("primary-7"))
                            //                                }
                            //                                .padding(.top, 16)
                            //                            }
                            
                            //                            SummaryOptionView(summary: summary, logPrompts: logPrompts)
                            
                            
                            
                            
                        }.padding(.top, 100)
                        
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingConfirmationDialog = true
                    }) {
                        Text("Selesai")
                            .foregroundStyle(Color("primary-6"))
                    }
                    .confirmationDialog(Text("Konfirmasi"),
                                        isPresented: $showingConfirmationDialog,
                                        titleVisibility: .visible,
                                        actions: {
                        Button(action: {let logPromptModels = logPrompts.map {
                            LogPrompt(userText: $0.user, modelResponse: $0.modelResponse)
                        }
                            let newSummary = SummaryRecord(summaryText: summary, logPrompts: logPromptModels)
                            modelContext.insert(newSummary)
                        navigateToHome = true}) { Text("Save")}
                        Button(action: {navigateToHome = true}) {Text("Discard").foregroundStyle(Color.red) }
                        Button("Cancel", role: .cancel) { }
                    },
                                        message: {
                        Text("Simpen nggak?")
                    }
                    )
                }
            }
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea(.all, edges: [.top, .bottom])
            
            NavigationLink(
                destination: HomeView()
                    .navigationBarBackButtonHidden(true),
                isActive: $navigateToHome,
                label: { EmptyView() }
            )
        }
    }
}

#Preview {
    SummaryView(shouldPopToRootView: .constant(false) ,summary: "Lorem ipsum dolor sit amet consectetur. Imperdiet donec ullamcorper purus diam pharetra tortor. Ultrices tincidunt pulvinar morbi tempor. Ultricies aenean et facilisi pellentesque odio orci. Quam velit non amet amet phasellus at eu lectus quam. Senectus tristique scelerisque in sagittis aliquam. Gravida rhoncus quam viverra porttitor donec aliquet.", logPrompts: [] )
}
