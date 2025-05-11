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
    @State private var shouldNavigate = false
    @State private var hasKeyboardShown: Bool = false
    @State private var hasKeyboardShownOnce: Bool = false
    
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
                        Text("Selesai bercerita")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("primary-6"))
                            .onTapGesture {
                                tempFeedback = promptManager.feedback;
                                tempFollowUp = promptManager.followUp;
                                promptManager.feedback = "Apakah kamu sudah merasa cukup untuk sekarang?";
                                promptManager.followUp = "";
                                isStoryDone = true; hasKeyboardShownOnce = false}
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
                    
                    HStack(alignment: .top, spacing:0){
                       
                         if(promptManager.isLoading){
                             LottieView(animation: .named("nyimakNeutral")).playbackMode(.playing(.toProgress(1, loopMode: .repeat(10)))).animationSpeed(1)
                                 .frame(width: 130.62, height: 106)
                        }
                        else if (promptManager.expression == "senang" || promptManager.expression == "sedih"){
                            LottieView(animation: .named(promptManager.expression)).playbackMode(.playing(.toProgress(1, loopMode: .repeat(10)))).animationSpeed(1)
                                .frame(width: 130.62, height: 106)
                        }
                        else{
                            LottieView(animation: .named("happyDefaultIdle")).playbackMode(.playing(.toProgress(1, loopMode: .repeat(10)))).animationSpeed(1)
                                .frame(width: 130.62, height: 106)
                            
                            
                        }
                        
                        BubbleChatView(message: promptManager.feedback, followUp: promptManager.followUp, isKeyboardActive: hasKeyboardShownOnce)
                    }
                    .padding(.bottom, 8)
                    
                    Rectangle()
                        .fill(Color(.gray.opacity(0.2)))
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                }else{
                    Spacer(minLength: isTextFieldFocused ? 0 : 60 )
                    VStack{
                        BubbleChatView(message: promptManager.feedback, followUp: promptManager.followUp, isKeyboardActive: hasKeyboardShown)
                        if promptManager.isLoading {
                            LottieView(animation: .named("nyimakNeutral")).playbackMode(.playing(.toProgress(1, loopMode: .repeat(10)))).animationSpeed(1)
                                .frame(width: 172, height: 174)
                        }
                        else if (promptManager.expression == "senang" || promptManager.expression == "sedih"){
                            LottieView(animation: .named(promptManager.expression)).playbackMode(.playing(.toProgress(1, loopMode: .repeat(10)))).animationSpeed(1)
                                .frame(width: 172, height: 174)
                        }
                        else{
                            LottieView(animation: .named("happyDefaultIdle")).playbackMode(.playing(.toProgress(1, loopMode: .repeat(10)))).animationSpeed(1)
                                .frame(width: 172, height: 174)
                        }
                    }
                }
                
                if(isStoryDone){
                    Spacer()
                    HStack(alignment: .center, spacing: 20){
                        VStack{
                            Image("story-sudah").resizable().scaledToFit().frame(width: 136, height: 111)
                            Text("Iya, sudah cukup").font(.headline).fontWeight(.semibold).foregroundStyle(Color("primary-6"))
                               
                                
                        }
                        .onTapGesture {shouldNavigate = true}
                    }
                    Spacer()
                    
                    
                    
                    
                }else{
                    
                    VStack{
                        ZStack(alignment: .bottom){
                            ScrollView{
                                VStack{
                                    
                                    TextField("Tuliskan di sini…", text: $promptManager.userPrompt, axis: .vertical)
                                        .disableAutocorrection(true)
                                        .multilineTextAlignment(hasKeyboardShownOnce ? .leading : .center)
                                        .focused($isTextFieldFocused)       // ← this makes i focusable
                                        .padding(12)
                                        .frame(maxWidth: .infinity)
                                    
                                        .toolbar {
                                            ToolbarItemGroup(placement: .keyboard) {
                                                Spacer()
                                                Button("Selesai") {
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
                            KeyboardButtonView(hasKeyboardShown: $hasKeyboardShown, isMicActive: $isMicActive, isSpeaking: $isSpeaking, hasKeyboardShownOnce: $hasKeyboardShownOnce).onChange(of: hasKeyboardShown) { newValue in
                                isTextFieldFocused = newValue
                                print("Keyboard Button Tapped \(hasKeyboardShown)")
                                if hasKeyboardShown == false {
                                    isTextFieldFocused = false
                                    if promptManager.userPrompt != "" {
                                        promptManager.generateResponse()
                                    }
                                }
                            }
                            
                            //mic button
                            MicButtonView(hasKeyboardShown: $hasKeyboardShown, isMicActive: $isMicActive, isSpeaking: $isSpeaking, isLoading: $promptManager.isLoading).onChange(of: isMicActive) { newValue in
                                
                                
                                if isMicActive == false {
                                    //jika di nonaktifkan akan meminta response prompt
                                    speechRecognizer.stopRecording()
                                    if promptManager.userPrompt != "" {
                                        promptManager.generateResponse()
                                    }
                                } else {
                                    //jika diaktifkan akan merekam suara
                                    isSpeaking = false
                                    speechManager.stop()
                                    try! speechRecognizer.startRecording()
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                
                
            }
            .padding(.horizontal)
            
        }
        .onAppear {
            
            if(emotionName == "senang"){
                promptManager.feedback = "Apa yang sedang kamu rasakan sekarang ?"
                promptManager.expression = "senang-start"
            }
        }
        .onChange(of: promptManager.promptLimit) { newValue in
            if newValue >= 10 {
                promptManager.promptLimit = 0
                promptManager.logPrompts.removeAll()
                shouldNavigate = true
                
            }
        }
        
        .onChange(of: speechRecognizer.transcribedText) { newValue in
            promptManager.userPrompt = newValue
        }
        
        // hidden link that actually does the navigation
        .background(
            NavigationLink(
                destination: LoadingSummaryView(rootIsActive: self.$isActive, logPrompts: promptManager.logPrompts).navigationBarBackButtonHidden(true),      // <-- the view you want to go t
                isActive: $shouldNavigate,
                label: { EmptyView() }
            )
            .isDetailLink(false)
            .hidden()
        )
        
        
    }
    
}



#Preview {
    StoryView(emotionName: "senang")
}
