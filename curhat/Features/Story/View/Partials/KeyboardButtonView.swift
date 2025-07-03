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
    @Binding var isLoading: Bool
    
    @StateObject private var promptManager = PromptManager()
    
    var body: some View {
        let keyboardColor: Color = hasKeyboardShown ? Color("story-icon-color") : Color("bg-custom")
        let keyboardBorderColor: Color = isLoading ? Color("gray-disabled") : (isMicActive ? Color("gray-disabled"): Color("story-icon-color"))
        let keyboardIconColor: Color = isLoading ? Color("gray-disabled") : (hasKeyboardShown ? Color(.white) : (isMicActive ? Color("gray-disabled"): Color("story-icon-color")))
        
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
             

                
            }
    }
}


