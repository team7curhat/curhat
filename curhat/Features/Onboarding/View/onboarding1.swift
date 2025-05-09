//
//  Untitled.swift
//  Kalkulator Cicilan Rumah
//
//  Created by Muhammad Ferial Ishakh on 07/05/25.
//

import SwiftUI


struct onboarding1: View {
    @AppStorage("userNickname") private var nickname: String = ""
    
    var body: some View {
        if(!nickname.isEmpty){
            HomeView()
        }else{
            
            
            NavigationStack{
                VStack(spacing: 20) {
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
                    
                    //Character
                    
                    // Button
                    NavigationLink (destination: onboarding2().navigationBarBackButtonHidden(true)){
                        Text("Ketuk gigiku untuk memulai.")
                        
                    }
                }
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        }
    }

struct onboarding1_Previews: PreviewProvider {
    static var previews: some View {
        onboarding1()
    }
}

