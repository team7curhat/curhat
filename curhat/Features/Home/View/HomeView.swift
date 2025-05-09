//
//  HomeView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 06/05/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedFilter: String = "Semua"
    let filters = ["Semua", "Marah", "Kecewa"]
    let history = [
        ("Marah", "05 Mei 2025", "20:00"),
        ("Senang", "05 Mei 2025", "20:00"),
        ("Kecewa", "05 Mei 2025", "20:00")
    ]
    
    @AppStorage("userNickname") private var nickname: String = ""
    
    var body: some View {
        if(nickname.isEmpty){
            onboarding1()
        }else{
            VStack {
                Spacer()
                
                // Greeting
                Text("Halo \(nickname), Ada cerita apa hari ini?")
                    .font(.title2).bold()
                    .padding(.top, 100)
                    .frame(width:232)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                
                VStack (spacing: 0){
                    WaveAnimateView()
                    ZStack (alignment: .bottom){
                        NavigationLink(destination: AwarenessView().navigationBarBackButtonHidden(true)){
                            Image("persona-home")
                                .frame(maxWidth:.infinity)
                        }
                        
                        Text("Ketuk aku untuk mulai bercerita")
                            .font(.body)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 30)
                        
                    }
                    .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .bottom)
                    .background(.primary2)
                    
                }
                .edgesIgnoringSafeArea(.all)
                
                
            }
            .navigationTitle("EMOCI")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    //backbutton
                    Button(action:{UserDefaults.standard.removeObject(forKey: "userNickname")} ){
                        Image(systemName: "repeat")
                    }
                }
                
            }
        }
    }
    
    //    }
}



#Preview {
    NavigationView {
        HomeView()
    }
}


struct WaveAnimateView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            AnimatedTopWaveImage(color: Color.primary3, height: 120)
            AnimatedTopWaveImage(color: Color.white, height: 90)
            AnimatedTopWaveImage(color: Color.primary3, height: 60)
            AnimatedTopWaveImage(color: Color.primary2, height: 30)
        }
    }
}
