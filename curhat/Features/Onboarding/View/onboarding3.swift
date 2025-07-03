//  onboarding 2.swift
//  curhat
//
//  Created by Muhammad Ferial Ishakh on 07/05/25.
//
//

import SwiftUI

struct onboarding3: View {
    @AppStorage("userNickname") private var nickname = "joj"
    @Environment(\.dismiss) var dismiss
    
    @State private var tempNickname: String = ""
    @State private var goHome = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
      
            ZStack(alignment: .bottom){
                Color("bg-custom")
                    .edgesIgnoringSafeArea(.all)
                
                Image("onboarding3")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .offset(x: 0, y: isTextFieldFocused ? -100 : 0).animation(.bouncy, value: isTextFieldFocused)
                    
                VStack() {
                    
                 
                        VStack(spacing: 15){
                            VStack(spacing: 12){
                                Text("Namaku Ochi!")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                Text("Kamu lebih nyaman dipanggil siapa?")
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.center)
                            }
                            VStack {
                                TextField("", text: $tempNickname, prompt: Text("Tuliskan di sini…").foregroundStyle(.gray))
                                    .padding(12)
                                    .font(.system(.title2, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary7)
                                    .multilineTextAlignment(.center)
                                    .disableAutocorrection(true)
                                    .background(Color("text-input"))
                                    .cornerRadius(10)
                                    .frame(maxWidth: .infinity)
                                    .focused($isTextFieldFocused)
                                    .onAppear {
                                        tempNickname = nickname
                                    }
                            }
                           
                           
                        }
                        .padding(.bottom, isTextFieldFocused ? 100 : 0).animation(.bouncy, value: isTextFieldFocused)
                       
                        
                        VStack{
                           
                           
                            
                            Button("Simpan") {
                                nickname = tempNickname
                                goHome = true
                            }
                            .fontWeight(.bold)
                            .foregroundStyle(.primary7)
                            .frame(maxWidth:.infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .background(tempNickname.isEmpty ? Color.gray : Color.white)
                            .cornerRadius(15).disabled(tempNickname.isEmpty)
                            
                            NavigationLink(
                                destination: HomeView()
                                    .navigationBarBackButtonHidden(true),
                                isActive: $goHome
                            ) {
                                EmptyView()
                            }
                            .hidden()
                            
                        }
                        .padding(.bottom, 120)
                        .padding(.top, 20)
                
                }
                .padding()
            }
         
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward").foregroundColor(Color.primary6)
                    }
                }
        }
    }
    
}
struct onboarding3_Previews: PreviewProvider {
    static var previews: some View {
        onboarding3()
    }
}
