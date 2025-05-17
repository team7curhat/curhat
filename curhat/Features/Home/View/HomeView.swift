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
        NavigationStack{
            if(nickname.isEmpty){
                onboarding1()
            }else{
                
                ZStack{
                    Color("bg-custom")
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Spacer()
                        
                        // Greeting
                        Text("Halo \(nickname), Ada cerita apa hari ini?")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 160)
                            .padding(.bottom, 60)
                            .frame(width:200)
                            .foregroundColor(.primary6)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        ZStack {
                            VStack (spacing: 0){
                                
                                WaveAnimateView()
                                
                                VStack {
                                    
                                }.frame(maxWidth: .infinity, maxHeight: .infinity).background(.primary1)
                                
                            }
                            
                            
                            ZStack (alignment: .bottom){
                                NavigationLink(destination: StoryView(emotionName: "senang").navigationBarBackButtonHidden(true)){
                                    Image("persona-homepage")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth:.infinity)
                                    
                                }
                                
                                Text("Ketuk aku untuk mulai bercerita")
                                    .font(.body)
                                    .foregroundColor(Color.white)
                                    .padding(.bottom, 30)
                                
                            }
                            .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .bottom)
                            
                        }.edgesIgnoringSafeArea(.all)
                        
                        
                        
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: HistoryListView()){
                                Image(systemName: "text.bubble")
                                    .foregroundColor(Color("primary-6"))
                            }
                            
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {

                            NavigationLink(destination: SettingsView()){
                                Image(systemName: "gearshape")
                                    .foregroundColor(Color("primary-6"))
                            }
                            
                        }
                        
                    }
                }.onAppear{
                    promptManager.logPrompts.removeAll()
                }
            }
            
            
            
        }
    }
}



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
