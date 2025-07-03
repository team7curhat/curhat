//
//  HomeView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 06/05/25.
//

import SwiftUI

struct HomeView: View {
    
    @AppStorage("userNickname") private var nickname: String = ""
    @StateObject private var promptManager = PromptManager()
    
    var body: some View {
        NavigationStack {
            if(nickname.isEmpty) {
                onboarding1()
            } else {
                ZStack {
                    // Background
                    Color("bg-custom")
                        .edgesIgnoringSafeArea(.all)
                    
                    // Main content
                    VStack(alignment: .leading) {
                        // Recent History Section - contained in its own fixed frame
                        Spacer()
                        VStack {
                            RecentHistoryView()
                        }
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                        .fixedSize(horizontal: false, vertical: true) // Prevent vertical expansion
                        
                        Spacer()
                        
                        // Greeting Section
                        VStack {
                            Text("Halo \(nickname), ada cerita apa hari ini?")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.top, 60) 
                                .padding(.bottom, 40)
                                .frame(width: 200)
                                .foregroundColor(.primary6)
                                .multilineTextAlignment(.center)
                            
//                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Bottom section with wave and persona
                        ZStack {
                            VStack(spacing: 0) {
                                WaveAnimateView()
                                
                                VStack {
                                    // Empty VStack for background
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(.primary1)
                            }
                            
                            ZStack(alignment: .bottom) {
                                NavigationLink(destination: StoryView(emotionName: "senang").navigationBarBackButtonHidden(true)) {
                                    Image("persona-homepage")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                }
                                
                                Text("Ketuk aku untuk mulai bercerita")
                                    .font(.body)
                                    .foregroundColor(Color.white)
                                    .padding(.bottom, 30)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        }
                        .frame(maxWidth: .infinity)
                        .edgesIgnoringSafeArea(.bottom)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gearshape")
                                    .foregroundColor(Color("primary-6"))
                            }
                        }
                    }
                }
                .onAppear {
                    promptManager.logPrompts.removeAll()
                }
            }
        }
    }}



#Preview {
    HomeView()
}


struct WaveAnimateView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            AnimatedTopWaveImage(color: Color.primary2, height: 120)
            AnimatedTopWaveImage(color: Color.primary1, height: 90)
            AnimatedTopWaveImage(color: Color.primary2, height: 60)
            AnimatedTopWaveImage(color: Color.primary1, height: 30)
        }
    }
}
