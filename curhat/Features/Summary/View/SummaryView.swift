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
    var body: some View {
        NavigationStack {
            ZStack{
                Color.purple.opacity(0.2) // Place your image here. Also to change the size apply .resizable() modifier...
                    .ignoresSafeArea()
                
                VStack{
                    LottieView(animation: .named("LoadingSummary"))
                        .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                        .animationSpeed(1.2)
                        .frame(width: 80, height: 80)
                    VStack {
                        Text("Summary").font(.title2).fontWeight(.bold)
                        Text("\(summary)")
                        
                        
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity).background(.gray.opacity(0.2))
                    .cornerRadius(12)
                    
                    VStack {
                        Button (action: { self.shouldPopToRootView = false } ){
                            Text("Pop to root")
                        }
                        
                       
                    }
                    .padding(.top, 20)
                    
                    
                    
                }
                .padding(20)
                .navigationBarBackButtonHidden(true) // Hide the default back button
                
            }
            
        }
        
        
        
    }
}

#Preview {
    SummaryView(shouldPopToRootView: .constant(false),summary: "" )
}
