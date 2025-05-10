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
    @Binding var isSpeaking: Bool
    @Binding var hasKeyboardShownOnce: Bool
    
    @StateObject private var promptManager = PromptManager()
    
    var body: some View {
        let keyboardColor: Color = hasKeyboardShown ? Color("primary-6") : .white
        let keyboardBorderColor: Color = isMicActive ? Color("gray-disabled"): Color("primary-6")
        let keyboardIconColor: Color = hasKeyboardShown ? Color(.white) : (isMicActive ? Color("gray-disabled"): Color("primary-6"))
        
        Circle()
            .fill(keyboardColor)
            .frame(width: 62, height: 62)
            .overlay(
                Circle()
                    .stroke(keyboardBorderColor, lineWidth: 2)
            )
            .overlay(
                Image(systemName: hasKeyboardShown ? "keyboard.fill" : "keyboard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 39, height: 31)
                    .foregroundColor(keyboardIconColor)
                
            )
            .onTapGesture {
                hasKeyboardShown.toggle()
                hasKeyboardShownOnce = true
             
                if hasKeyboardShown {
                    isMicActive = false
                    isSpeaking = false
                }
                
            }
    }
}


