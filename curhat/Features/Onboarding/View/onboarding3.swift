
//  onboarding 2.swift
//  Kalkulator Cicilan Rumah
//
//  Created by Muhammad Ferial Ishakh on 07/05/25.
//
//

import SwiftUI


struct onboarding3: View {
    
    @State private var nickname = ""
    
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                
                // Title
                VStack(spacing: 1){
                    Text("Ayo kita kenalan!")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top, -150)
                }
                VStack{
                    VStack(spacing: 15){
                        Text("Namaku Ochi!")
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Text("Kamu lebih nyaman dipanggil siapa?")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    VStack {
                        TextField("Masukkan namamu di sini", text: $nickname)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .frame(width: 347)
                        
                    }
                    
                    
                    //Character
                    
                    // Button
                    NavigationLink (destination: onboarding1()){
                            Text("OK!")
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .frame(width:100)
                                .padding(10)
                                .background(Color.gray)
                                .cornerRadius(15)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
struct onboarding3_Previews: PreviewProvider {
    static var previews: some View {
        onboarding3()
        }
    }



