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
        let micColor: Color = hasKeyboardShown ? .gray : (isMicActive ? Color("primary-6") : .white)
        let micBorderColor: Color = hasKeyboardShown ? .gray : Color("primary-6")
        let micIconColor: Color = hasKeyboardShown || isMicActive ? .white : Color("primary-6")
        
        
        Circle()
            .fill(micColor)
            .frame(width: 56, height: 56)
            .overlay(
                Circle()
                    .stroke(micBorderColor, lineWidth: 2)
            )
            .overlay(
                Image(systemName: isMicActive ? "microphone.fill" : "microphone")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 21, height: 21)
                    .foregroundColor(micIconColor)
            )
            .onTapGesture {
                
                //jika keyboard aktif, seluruh aksi tidak dapat dilakukan
                if hasKeyboardShown == false {
                    //jika diaktifkan akan menonaktifkan keyboard
                    isMicActive.toggle()
                    if isMicActive {
                        isSpeaking = false
                        try! speechRecognizer.startRecording()
                    } else {
                        //jika di nonaktifkan akan meminta response prompt
                        speechRecognizer.stopRecording()
                        if promptManager.userPrompt != "" {
                            promptManager.generateResponse()
                        }
                        
                    }
                    
                }
                    
                
        }
    }
    
}
