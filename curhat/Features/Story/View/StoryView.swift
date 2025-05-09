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
    
    // MARK: - Speech Manager
    @StateObject private var speechManager = SpeechManager()
    
    // <-- new state for navigation
    @State private var shouldNavigate = false
    @State private var hasKeyboardShown: Bool = false
    
    // Speech to Text Coordinator
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var lastAudioLevel: Float = 0.0
    let checkInterval: TimeInterval = 1.0
    
    @AppStorage("userNickname") private var nickname: String = ""
    
    @StateObject private var promptManager = PromptManager()

    
    var body: some View {
        
            VStack(spacing: 0) {

                HStack {
                    // Back button
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(Color("primary-6"))
                            .font(.system(size: 17, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    // Speaker button
                    Button(action: {
                        isSpeaking.toggle()
                        if isSpeaking {
                            speechManager.speak("\(promptManager.feedback)\n\n\(promptManager.followUp)")
                        } else {
                            speechManager.stop()
                        }
                    }) {
                        Image(systemName: isSpeaking ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            .resizable()
                            .frame(width: 25, height: 22)
                            .foregroundStyle(Color("primary-6"))
                    }
                    .padding(.trailing, 16)
                    
                    // Selesai button
                    Button(action: {
                        showingConfirmationDialog = true
                    }) {
                        Text("Selesai")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(promptManager.promptLimit == 0 ? Color.gray : Color("primary-6"))
                    }
                    .disabled(promptManager.promptLimit == 0)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                
                VStack{
                    
                    if(hasKeyboardShown){
                        
                        HStack(alignment: .top, spacing:0){
                            if(isSpeaking){
                                LottieView(animation: .named("SadTalking")).playbackMode(.playing(.toProgress(1, loopMode: .repeat(2.5)))).animationSpeed(1.2)
                                    .frame(width: 135.62, height: 132)
                                
                            }
                            else if(promptManager.isLoading){
                                Image("nyimak")
                            }
                            else if (promptManager.expression == "senang" || promptManager.expression == "sedih"){
                                Image(promptManager.expression)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130.62, height: 106)
                            }
                            else{
                                Image("senang")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130.62, height: 106)
                            }
                            
                            BubbleChatView(message: promptManager.feedback, followUp: promptManager.followUp, isKeyboardActive: hasKeyboardShown)
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
                                Image("nyimak")
                            }else{
                                Image(promptManager.expression)
                            }
                        }
                    }
                    
                    
                    
                    VStack{
                        ZStack(alignment: .bottom){
                            ScrollView{
                                VStack{
                                    
                                    TextField("Tuliskan di sini…", text: $promptManager.userPrompt, axis: .vertical)
                                        .disableAutocorrection(true)
                                        .multilineTextAlignment(hasKeyboardShown ? .leading : .center)
                                        .focused($isTextFieldFocused)       // ← this makes i focusable
                                        .padding(12)
                                        .frame(maxWidth: .infinity)
                                    
                                        .toolbar {
                                            ToolbarItemGroup(placement: .keyboard) {
                                                Spacer()
                                                Button("Selesai") {
                                                    // 3️⃣ Dismiss when “Done” is tapped
                                                    isTextFieldFocused = false
                                                    promptManager.generateResponse()
                                                }
                                            }
                                        }
                                        .onChange(of: isTextFieldFocused) {
                                            hasKeyboardShown = true
                                        }
                                    
                                }
                                //                            .background(.blue)
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
                            KeyboardButtonView(hasKeyboardShown: $hasKeyboardShown, isMicActive: $isMicActive).onChange(of: hasKeyboardShown) { newValue in
                                isTextFieldFocused = newValue
                            }
                            
                            //mic button
                            MicButtonView(hasKeyboardShown: $hasKeyboardShown, isMicActive: $isMicActive, isSpeaking: $isSpeaking)
                            
                        }
                        
                    }
                    
                    
                    
                }
                .padding(.horizontal)
                
            }
            .navigationBarHidden(true)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    //backbutton
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward").foregroundColor(Color.primary6)
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Image(systemName: isSpeaking
                          ?"speaker.wave.2.fill"
                          : "speaker.slash.fill")
                    .resizable()
                    .frame(width: 25, height: 22)
                    .foregroundStyle(Color("primary-6"))
                    .onTapGesture {
                        isSpeaking.toggle()
                        if isSpeaking {
                            // speak both feedback and follow-up
                            speechManager.speak("\(promptManager.feedback)\n\n\(promptManager.followUp)")
                        } else {
                            speechManager.stop()
                        }
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        showingConfirmationDialog = true
                    }){
                        Text("Selesai").font(.body).fontWeight(.semibold)
                    }.disabled(promptManager.promptLimit == 0)
                }
            }
            .alert(Text("Akhiri Cerita?"),
                   isPresented: $showingConfirmationDialog,
                   actions: {
                Button("Ya akhiri", role: .destructive) {
                    shouldNavigate = true
                }
                Button("Batal", role: .cancel) { }
            }, message: {
                Text("Kamu masih dalam proses bercerita. Jika berhenti sekarang, kamu akan langsung ke halaman akhir dan tidak bisa melanjutkan cerita ini.")
            }
            )
            .onAppear {
                
                if(emotionName == "senang"){
                    promptManager.feedback = "Apa yang bikin kamu senang hari ini?"
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
    
    func startAudioLevelMonitor() {
        Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { _ in
            let currentLevel = speechRecognizer.audioLevel
            lastAudioLevel = currentLevel
        }
    }
    
    
}



#Preview {
    StoryView(emotionName: "senang")
}
