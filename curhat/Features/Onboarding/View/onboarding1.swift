//
//  Untitled.swift
//  curhat
//
//  Created by Muhammad Ferial Ishakh on 07/05/25.
//

import SwiftUI


struct onboarding1: View {
    @AppStorage("userNickname") private var nickname = ""
    @State private var isNavigating = false
    var body: some View {
        if (!nickname.isEmpty){
            HomeView()
        }else{
            NavigationStack{
                ZStack(alignment: .bottom){
                    Image("onboarding1")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                    VStack(spacing: 20) {
                        Spacer()
                        Spacer()
                        Spacer()
                        // Title
                        VStack(spacing: 20){
                            Text("Selamat Datang")
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Text("di EMOCHI")
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        }
                        VStack(){
                            Text("Ruang Aman Tuk")
                                .font(.system(.title2, design: .rounded))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Text("Melepas Beban")
                                .font(.system(.title2, design: .rounded))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                        //===================================  Button Gambar  ====================================
                    }
                    Image("Gigi")
                        .resizable()
                        .frame(width: 170, height: 100)
                        .onTapGesture {
                            print("Gambar Gigi ditekan")
                            isNavigating = true
                        }
                        .padding(.bottom, 190)
                    VStack{
                        Text("Ketuk gigiku untuk memulai")
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 60)
                    }
                    NavigationLink(destination: onboarding2().navigationBarBackButtonHidden(true),
                                   isActive: $isNavigating) {
                        EmptyView()
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
}
struct onboarding1_Previews: PreviewProvider {
    static var previews: some View {
        onboarding1()
    }
}
