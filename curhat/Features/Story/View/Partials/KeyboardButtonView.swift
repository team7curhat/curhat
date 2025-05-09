//
//  KeyboardButtonView.swift
//  curhat
//
//  Created by Sakti Pardano on 10/05/25.
//
import SwiftUI
struct KeyboardButtonView: View {
    
    @Binding var hasKeyboardShown: Bool
    @Binding var isMicActive: Bool
    @StateObject private var promptManager = PromptManager()
    
    var body: some View {
        let keyboardColor: Color = isMicActive ? .gray : (hasKeyboardShown ? Color("primary-6") : .white)
        let keyboardBorderColor: Color = isMicActive ? .gray : Color("primary-6")
        let keyboardIconColor: Color = isMicActive || hasKeyboardShown ? .white : Color("primary-6")
        
        Circle()
            .fill(keyboardColor)
            .frame(width: 56, height: 56)
            .overlay(
                Circle()
                    .stroke(keyboardBorderColor, lineWidth: 2)
            )
            .overlay(
                Image(systemName: hasKeyboardShown ? "keyboard.fill" : "keyboard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 21, height: 21)
                    .foregroundColor(keyboardIconColor)
                
            )
            .onTapGesture {
                //jika mic aktif, seluruh aksi tidak dapat dilakukan
                if isMicActive == false {
                    hasKeyboardShown.toggle()
                    //jika keyboard diaktifkan
                    if hasKeyboardShown {
                        isMicActive = false
                    } else {
                        promptManager.generateResponse()
                    }
                    
                }
                
            }
    }
}
