//
//  MicButtonVIew.swift
//  curhat
//
//  Created by Sakti Pardano on 10/05/25.
//

import SwiftUI
struct MicButtonView: View {
    
    @Binding var hasKeyboardShown: Bool
    @Binding var isMicActive: Bool
    @Binding var isSpeaking: Bool
    @Binding var isLoading: Bool
    
    @StateObject private var speechManager = SpeechManager()
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @StateObject private var promptManager = PromptManager()
    
    
    var body: some View {
        let micColor: Color = isMicActive ? Color("story-icon-color") : Color("bg-custom")
        let micBorderColor: Color = isLoading ? Color("gray-disabled") : Color("story-icon-color")
        let micIconColor: Color = isLoading ? Color("gray-disabled") : (  isMicActive ? .white : Color("story-icon-color"))
        
        
        Circle()
            .fill(micColor)
            .frame(width: 62, height: 62)
            .overlay(
                Circle()
                    .stroke(micBorderColor, lineWidth: 2)
            )
            .overlay(
                Image(systemName: isMicActive ? "microphone.fill" : "microphone")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 34)
                    .foregroundColor(micIconColor)
            )
            .onTapGesture {
                

                isMicActive.toggle();
                hasKeyboardShown = false
                
        }
    }
    
}

