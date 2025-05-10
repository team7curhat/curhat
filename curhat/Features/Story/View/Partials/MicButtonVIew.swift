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
    
    
    @StateObject private var speechManager = SpeechManager()
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @StateObject private var promptManager = PromptManager()
    
    
    var body: some View {
        let micColor: Color = isMicActive ? Color("primary-6") : .white
        let micBorderColor: Color = hasKeyboardShown ? Color("gray-disabled") : Color("primary-6")
                let micIconColor: Color = isMicActive ? .white :(hasKeyboardShown ? Color("gray-disabled"): Color("primary-6"))
        
        
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
                
                //jika keyboard aktif, seluruh aksi tidak dapat dilakukan
                if hasKeyboardShown == false {
                    //jika diaktifkan akan menonaktifkan keyboard
                    isMicActive.toggle()
//                    if isMicActive {
//                        
//                    } 
                    
                }
                    
                
        }
    }
    
}
