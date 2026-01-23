//  onboarding 2.swift
//  curhat
//
//  Created by Muhammad Ferial Ishakh on 07/05/25.
//
//

import SwiftUI

struct ChangeUsernameView: View {
    @AppStorage("userNickname") private var nickname = "joj"
    @Environment(\.dismiss) var dismiss
    
    @State private var tempNickname: String = ""
    
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
                                Text("I'm Ochi!")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                Text("Who do you prefer to be called?")
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.center)
                            }
                            VStack {
                                TextField("", text: $tempNickname, prompt: Text("Write it here...").foregroundStyle(.gray))
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
                           
                           
                            
                            Button("Save") {
                                nickname = tempNickname
                                
                                    
                                    dismiss()
                               
                            }
                            .fontWeight(.bold)
                            .foregroundStyle(.primary7)
                            .frame(maxWidth:.infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .background(tempNickname.isEmpty ? Color.gray : Color.white)
                            .cornerRadius(15).disabled(tempNickname.isEmpty)
                            
        
                            
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

#Preview{
    ChangeUsernameView()
}
