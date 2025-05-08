
//  onboarding 2.swift
//  curhat
//
//  Created by Muhammad Ferial Ishakh on 07/05/25.
//
//

import SwiftUI

struct onboarding3: View {
    
    @AppStorage("nickname") private var nickname = ""
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottom){
                Image("onboarding3")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                VStack(spacing: 20) {
                    Spacer()
                    // Title
                    VStack{
                        Text("Ayo kita kenalan!")
                            .font(.system(.title, design: .rounded))
                            .foregroundStyle(.primary10)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.top,-380)
                        VStack{
                            VStack(spacing: 15){
                                Text("Namaku Ochi!")
                                    .font(.system(.title2, design: .rounded))
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                Text("Kamu lebih nyaman dipanggil siapa?")
                                    .font(.system(.body, design: .rounded))
                                    .foregroundStyle(.white)
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
                            // Button
                            VStack{
                                NavigationLink (destination: onboarding1()){
                                    Text("OK!")
                                        .font(.system(.title, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                        .frame(width:100)
                                        .padding(10)
                                        .background(Color.primary8)
                                        .cornerRadius(15)
                                }
                            }
                            .safeAreaPadding()
                        }
                        .padding(.bottom, 200)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }
    }
    
    struct onboarding3_Previews: PreviewProvider {
        static var previews: some View {
            onboarding3()
        }
    }
}
