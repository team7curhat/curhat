//
//  Untitled.swift
//  curhat
//
//  Created by Muhammad Ferial Ishakh on 07/05/25.
//

import SwiftUI


struct onboarding1: View {
    @State private var isNavigating = false
    @Namespace private var transitionNamespace
    var body: some View {
        
            ZStack(alignment: .bottom) {
                Color("bg-custom")
                    .edgesIgnoringSafeArea(.all)
                
                Image("onboarding1")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                
                VStack(spacing: 20) {
                    Spacer()
                    Image("Title")
                        .resizable()
                        .frame(width: 300, height: 100)
                    Spacer()
                    Spacer()
                    Spacer()
                    VStack{
                        ZStack {
                            Image("Mulut")
                                .resizable()
                                .frame(width: 190, height: 101)
                            
                            
                            Image("Gigi")
                                .resizable()
                                .frame(width: 170, height: 100)
                                .matchedTransitionSource(id: "gigi", in: transitionNamespace)
                                .onTapGesture {
                                    isNavigating = true
                                }
                        }
                        .padding(.bottom, 1)
                    }
                    
                    Text("Ketuk gigiku untuk memulai")
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 60)
                }
                
                NavigationLink(
                    destination: onboarding2()
                        .navigationTransition(.zoom(sourceID: "gigi", in: transitionNamespace))
                        .navigationBarBackButtonHidden(true),
                    isActive: $isNavigating
                ) {
                    EmptyView()
                }
            }
            .ignoresSafeArea()
        }
}

struct onboarding1_Previews: PreviewProvider {
    static var previews: some View {
        onboarding1()
    }
}

