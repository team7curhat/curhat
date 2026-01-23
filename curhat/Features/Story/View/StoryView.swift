//
//  StoryView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 06/05/25.
//

import SwiftUI
import GoogleGenerativeAI
import Lottie


struct StoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var emotionName: String
    @State private var isActive : Bool = false
    
    // MARK: - Focus State
    @FocusState private var isTextFieldFocused: Bool
    
    // MARK: - View State
    @State private var isMicActive: Bool = false
    @State private var isSpeaking: Bool = false
    @State private var showingConfirmationDialog: Bool = false
    
    // <-- new state for navigation
    @ObservedObject var navigationManager = NavigationManager.shared
    @State private var hasKeyboardShown: Bool = false
    @State private var hasKeyboardShownOnce: Bool = false
    
    @State private var arrayUserPrompts: [String] = []
    
    // MARK: - Speech Manager
    @StateObject private var speechManager = SpeechManager()
    
    // Speech to Text Coordinator
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    // Prompt Manager
    @StateObject private var promptManager = PromptManager()
    
    @AppStorage("userNickname") private var nickname: String = ""
    
    @State private var tempFeedback: String = ""
    @State private var tempFollowUp: String = ""
    
    
    @State private var isStoryDone: Bool = false
    
    
    
    var body: some View {
        ZStack{
            Color("bg-custom")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                HStack {
                    // Back button
                    if(promptManager.promptLimit == 0){
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(Color("primary-6"))
                                .font(.system(size: 17, weight: .semibold))
                        }
                    }
                    
                    
                    Spacer()
                    
                    
                    if(promptManager.promptLimit != 0 ){
                        if (!isStoryDone){
                            HStack(alignment: .center, spacing: 20){
                                
                                   PopoverView()
                                    
                                    
                                Text("Finish the story")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("primary-6"))
                                    .onTapGesture {
                                        tempFeedback = promptManager.feedback;
                                        tempFollowUp = promptManager.followUp;
                                        promptManager.feedback = "Have you had enough for now?";
                                        promptManager.followUp = "";
                                        isStoryDone = true;
                                        hasKeyboardShownOnce = false
                                    }
                            }
                            
                        }
                        else{
                            Image(systemName: "xmark").resizable().scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color("primary-6"))
                                .onTapGesture {
                                    promptManager.feedback = tempFeedback;
                                    promptManager.followUp = tempFollowUp;
                                    isStoryDone = false; hasKeyboardShownOnce = true}
                        }
                    }
                    
                }
                .padding(.horizontal,24)
                .padding(.vertical, 12)
                
                VStack{
                    
                    if(hasKeyboardShownOnce){
                        
                        ZStack(alignment: .topLeading){
                            VStack{
                                if(promptManager.isLoading){
                                    LottieView(animation: .named("nyimakNeutral")).playbackMode(.playing(.toProgress(1, loopMode: .repeat(10)))).animationSpeed(1)
                                        .frame(width: 130.62, height: 106)
                                }
                                else if (promptManager.expression == "happy" || promptManager.expression == "sad"){
                                    LottieView(animation: .named(promptManager.expression)).playbackMode(.playing(.toProgress(1, loopMode: .repeat(10)))).animationSpeed(1)
                                        .frame(width: 130.62, height: 106)
                                }
                                else{
                                    LottieView(animation: .named("happyDefaultIdle")).playbackMode(.playing(.toProgress(1, loopMode: .repeat(10)))).animationSpeed(1)
                                        .frame(width: 130.62, height: 106)
                                    
                                    
                                }
                            }.offset(x: -60, y: 0)
                            
                            
                            BubbleChatView(message: promptManager.feedback, followUp: promptManager.followUp, isKeyboardActive: hasKeyboardShownOnce).frame(width: 280).offset(x: 45, y: 0)
                        }
                        .padding(.bottom, 8)
                        .onShake {
                            promptManager.reloadQuestions()
                        }
                        
                        
                        //divider
                        Rectangle()
                            .fill(Color(.gray.opacity(0.2)))
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                    }else{
                        Spacer(minLength: isTextFieldFocused ? 0 : 60 )
                        VStack{
                            BubbleChatView(message: promptManager.feedback, followUp: promptManager.followUp, isKeyboardActive: hasKeyboardShown)
                            if promptManager.isLoading {
                                LottieView(animation: .named("nyimakNeutral")).playbackMode(.playing(.toProgress(1, loopMode: .repeat(.infinity)))).animationSpeed(1)
                                    .frame(width: 172, height: 174)
                            }
                            else if (promptManager.expression == "happy" || promptManager.expression == "sad"){
                                LottieView(animation: .named(promptManager.expression)).playbackMode(.playing(.toProgress(1, loopMode: .repeat(10)))).animationSpeed(1)
                                    .frame(width: 172, height: 174)
                            }
                            else{
                                LottieView(animation: .named("happyDefaultIdle")).playbackMode(.playing(.toProgress(1, loopMode: .repeat(10)))).animationSpeed(1)
                                    .frame(width: 172, height: 174)
                            }
                        }.onShake {
                            promptManager.reloadQuestions()
                        }
                    }
                    
                    if(isStoryDone){
                        Spacer()
                        HStack(alignment: .center, spacing: 20){
                            VStack{
                                Image("story-sudah").resizable().scaledToFit().frame(width: 136, height: 111)
                                Text("Yes, it's enough").font(.headline).fontWeight(.semibold).foregroundStyle(Color("primary-6"))
                                
                                
                            }
                            .onTapGesture {
                                navigationManager.setStoryActive(setStoryActive:  true)
                                
                                print(navigationManager.hasStoryActive)}
                        }
                        Spacer()
                        
                        
                        
                        
                    }else{
                        
                        VStack{
                            ZStack(alignment: .bottom){
                                ScrollView{
                                    VStack{
                                        
                                        TextField("", text: $promptManager.userPrompt, prompt: Text("Write it here...").foregroundStyle(.gray), axis: .vertical)
                                            .foregroundStyle(Color("body-text"))
                                            .opacity(isMicActive ? 0 : 1)
                                            .disableAutocorrection(true)
                                            .multilineTextAlignment(hasKeyboardShownOnce ? .leading : .center)
                                            .focused($isTextFieldFocused)       // ← this makes i focusable
                                            .padding(12)
                                            .frame(maxWidth: .infinity)
                                            .toolbar {
                                                ToolbarItemGroup(placement: .keyboard) {
                                                    Spacer()
                                                    Button("Done") {
                                                        // 3️⃣ Dismiss when “Done” is tapped
                                                        isTextFieldFocused = false
                                                        
                                                        if(promptManager.userPrompt != ""){
                                                            promptManager.generateResponse()
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                            .onChange(of: isTextFieldFocused) { focused in
                                                hasKeyboardShown = focused
                                                hasKeyboardShownOnce = true
                                                if focused {
                                                    isMicActive = false
                                                    isSpeaking = false
                                                }
                                            }
                                        
                                        
                                    }
                                }
                                
                                LottieView(animation: .named("SoundWave2")).playbackMode(.playing(.toProgress(1, loopMode: .loop))).animationSpeed(1.2)
                                    .frame(width: 80, height: 80)
                                
                                // fixed size so layout never changes
                                    .opacity(isMicActive ? 1 : 0)
                                    .offset(x: 0, y: 10)
                                // hidden when off
                            }
                            
                        }.padding(.top,20)
                        
                        
                        Spacer()
                        
                        
                        
                        
                        
                        ZStack{
                            HStack(alignment: .center, spacing: 48) {
                                
                                //keyboard button
                                KeyboardButtonView(hasKeyboardShown: $hasKeyboardShown, isMicActive: $isMicActive, isSpeaking: $isSpeaking, hasKeyboardShownOnce: $hasKeyboardShownOnce, isLoading: $promptManager.isLoading).onChange(of: hasKeyboardShown) { newValue in
                                    isTextFieldFocused = newValue
                                 
                                    if hasKeyboardShown == false {
                                        isTextFieldFocused = false
                                    }
                                }
                                
                                //mic button
                                MicButtonView(hasKeyboardShown: $hasKeyboardShown, isMicActive: $isMicActive, isSpeaking: $isSpeaking, isLoading: $promptManager.isLoading).onChange(of: isMicActive) { newValue in
                                    
                                    
                                    if isMicActive == false {
                                        //jika di nonaktifkan akan meminta response prompt
                                        speechRecognizer.stopRecording()
                                        speechRecognizer.transcribedText = ""
                                        if promptManager.userPrompt != "" {
                                            promptManager.generateResponse()
                                            
                                        }
                                    } else {
                                        //jika diaktifkan akan merekam suara
                                        isSpeaking = false
                                        speechManager.stop()
                                        try! speechRecognizer.restartAudioBuffer()
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    
                }
                .padding(.horizontal)
                
            }
            .onAppear {
                
                if(emotionName == "happy"){
                    promptManager.feedback = "What are you feeling right now?"
                    promptManager.expression = "senang-start"
                }
            }
            .onChange(of: promptManager.promptLimit) { newValue in
                if newValue >= 10 {
                    promptManager.promptLimit = 0
                    
                  
                    
                    navigationManager.setStoryActive(setStoryActive: true)
                    
                }
            }
            
            .onChange(of: speechRecognizer.transcribedText) { newValue in
                promptManager.userPrompt = newValue
            }
            
            // hidden link that actually does the navigation
            .background(
                NavigationLink(
                    destination: LoadingSummaryView(rootIsActive: self.$isActive, logPrompts: promptManager.logPrompts).navigationBarBackButtonHidden(true),
                    isActive: $navigationManager.hasStoryActive){
                        EmptyView()
                    }
            )
            
        }
        
        
        
        
    }
    
}



#Preview {
    StoryView(emotionName: "happy")
}
