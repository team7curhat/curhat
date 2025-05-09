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
    // MARK: - Model
    let model = GeminiModel.shared.generativeModel
    
    
    @Environment(\.dismiss) private var dismiss
    
    var emotionName: String
    
    @State private var isActive : Bool = false
    
    
    
    // MARK: - Focus State
    @FocusState private var isTextFieldFocused: Bool
    
    // MARK: - View State
    @State private var userPrompt: String = ""
    @State private var isMicActive: Bool = false
    @State private var isLoading: Bool = false
    @State private var isSpeaking: Bool = false
    @State private var showingConfirmationDialog: Bool = false
    
    // MARK: - Logging & Limits
    @State private var logPrompts: [String] = []
    @State private var promptLimit: Int = 0
    
    // MARK: - Feedback Content
    @State private var expression: String = "sedih"    // default image
    @State private var feedback: String = "Apa yang bikin kamu sedih hari ini?"// feedback text
    @State private var followUp: String = ""            // follow-up question
    
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
    
    @State private var indexPromts: Int = 1;
        
    
    var body: some View {
        NavigationView{
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
                            speechManager.speak("\(feedback)\n\n\(followUp)")
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
                            .foregroundColor(promptLimit == 0 ? Color.gray : Color("primary-6"))
                    }
                    .disabled(promptLimit == 0)
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
                            else if( isLoading){
                                Image("nyimak")
                            }
                            else if (expression == "senang" || expression == "sedih"){
                                Image(expression)
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
                            
                            
                            
                            BubbleChatView(message: feedback, followUp: followUp, isKeyboardActive: hasKeyboardShown)
                        }
                        .padding(.bottom, 8)
                        
                        Rectangle()
                            .fill(Color(.gray.opacity(0.2)))
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                    }else{
                        Spacer(minLength: isTextFieldFocused ? 0 : 60 )
                        VStack{
                            BubbleChatView(message: feedback, followUp: followUp, isKeyboardActive: hasKeyboardShown)
                            if isLoading {
                               
                                Image("nyimak")
                            }else{
                                Image(expression)
                            }
                        }
                    }
                    
                    
                    
                    VStack{
                        ZStack(alignment: .bottom){
                            ScrollView{
                                VStack{
                                    
                                    TextField("Tuliskan di sini…", text: $userPrompt, axis: .vertical)
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
                                                    generateResponse()
                                                    indexPromts = indexPromts + 1
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
                            
                            if isMicActive {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 56, height: 56)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray, lineWidth: 2)
                                    )
                                    .overlay(
                                        Image(systemName: "keyboard")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 21, height: 21)
                                            .foregroundColor(Color.white)
                                    )
                                    .onTapGesture {
                                        
                                    }
                                
                            } else {
                                Circle()
                                    .fill(isTextFieldFocused ? Color("primary-6") : Color.white)
                                    .frame(width: 56, height: 56)
                                    .overlay(
                                        Circle()
                                            .stroke(Color("primary-6"), lineWidth: 2)
                                    )
                                    .overlay(
                                        Image(systemName: isTextFieldFocused ? "keyboard.fill" : "keyboard")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 21, height: 21)
                                            .foregroundColor(isTextFieldFocused ? .white : Color("primary-6"))
                                        
                                    )
                                    .onTapGesture {
                                        
                                        hasKeyboardShown = true
                                        isTextFieldFocused.toggle()
                                       
                                    }
                            }
                            
                            
                            Circle()
                                .fill(isMicActive ? Color("primary-6") : Color.white)
                                .frame(width: 56, height: 56)
                                .overlay(
                                    Circle()
                                        .stroke(Color("primary-6"), lineWidth: 2)
                                )
                                .overlay(
                                    Image(systemName: isMicActive ? "microphone.fill" : "microphone")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 21, height: 21)
                                        .foregroundColor(isMicActive ? .white : Color("primary-6"))
                                )
                                .onTapGesture {
                                    isMicActive.toggle()
                                    if isMicActive {
                                        speechManager.stop()
                                        isSpeaking = false
                                        try? speechRecognizer.startRecording()
                                        startAudioLevelMonitor()
                                    } else {
                                        speechRecognizer.stopRecording()
                                        if (userPrompt != "") {
                                            isTextFieldFocused = false
                                            generateResponse()
                                            indexPromts = indexPromts + 1
                                        }
                                    }
                                }
                            
                        }
                        
                    }
                    
                    
                    
                }
                .padding(.horizontal)
                
            }
            .navigationBarHidden(true)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    
                    if indexPromts == 1 {
                        //backbutton
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.backward").foregroundColor(Color.primary6)
                        }
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
                            speechManager.speak("\(feedback)\n\n\(followUp)")
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
                    }.disabled(promptLimit == 0)
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
                    feedback = "Apa yang bikin kamu senang hari ini?"
                    expression = "senang-start"
                }
            }
            .onChange(of: promptLimit) { newValue in
                if newValue >= 10 {
                    promptLimit = 0
                    logPrompts.removeAll()
                    shouldNavigate = true
                    
                }
            }
            // hidden link that actually does the navigation
            .background(
                NavigationLink(
                    destination: LoadingSummaryView(rootIsActive: self.$isActive, logPrompts: logPrompts).navigationBarBackButtonHidden(true),      // <-- the view you want to go t
                    isActive: $shouldNavigate,
                    label: { EmptyView() }
                )
                .isDetailLink(false)
                .hidden()
            )
            
            
        }
        
        .onChange(of: speechRecognizer.transcribedText) { newValue in
            if isMicActive {
                userPrompt = newValue
            }
        }
    }
    
    func startAudioLevelMonitor() {
        Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { _ in
            let currentLevel = speechRecognizer.audioLevel
            lastAudioLevel = currentLevel
        }
    }
    
    
    func generateResponse() {
        let fullPrompt = """
        
        Nama user = \(nickname)
         
        jadilah teman curhat seperti persona ini:
                        - jadi pribadi yang supportive tetapi juga straight forward
                        - kamu bisa pakai bahasa untuk orang berusia 18-25 tahun
                          gunakan struktur percakapan curhat sebagai panduan dalam menyusun respons:
        
                
                        1. **Exploration**: tanyakan tentang kejadian yang mencakup siapa, apa, di mana, kapan, mengapa, dan bagaimana tapi jangan ditanya lagi kalau sudah dijelaskan di awal terkait siapa, apa, di mana, kapan, mengapa, dan bagaimananya buat bahasanya seperti best friend yang sangat care terhadap apa yang ingin diceritakan. Kalau dia sudah tidak mau ditanya, lanjut ke bagian reflection.
                        2. **Reflection**: tanyakan kepada user apa pelajaran atau makna dari tahapan sebelumnya.
                        3. **Regulation**: tanyakan langkah apa yang akan mereka ambil setelah melakukan refleksi.
        
                        Berikut log cerita user:
                        
                        \(logPrompts)
                        Berikut ini adalah jawaban dari user:
                        
                        \(userPrompt)
                        
                        Tugasmu:
        
                        - buat user merasa diperhatikan dengan menyebut namanya
                        - Analisis teks user tersebut dan tentukan ekspresi emosinya (hanya satu dari: senang atau sedih).
                        - Buatkan pertanyaan lanjutan (follow-up question) sesuai dengan tahap **struktur curhat** yang paling relevan saat ini.
                        - kamu hanya punya maksimal 10 pertanyaan
                        - Berikan feedback yang singkat maksimal 5 kata namun bermakna, sesuai dengan persona yang supportive dan straight forward.
                        - runtutan setiap bertanya adalah berikan dia feedback dulu baru kamu boleh lanjut kasih pertanyaan
        
        ⚠️ Jawab hanya dalam 1 objek JSON, contoh:
        {"expression":"senang","follow_up_question":"Apa …?","feedback":"Keren …"}
        JANGAN gunakan array untuk `expression`, dan JANGAN sertakan ```json fences```. PERHATIKAN JANGAN GUNAKAN ```json fences```.
        
        """
        
        isLoading   = true
        feedback = "Oh jadi gitu, aku paham sih kondisinya"
        speechManager.stop()
        
        logPrompts.append(userPrompt)
        
        print(logPrompts)
        
        Task {
            defer { isLoading = false; userPrompt = "" }
            do {
                print("masuk")
                let result = try await model.generateContent(fullPrompt)
                let text   = result.text ?? ""
                promptLimit = promptLimit + 1
                print("Hasil: \(text)")
                if
                    let data = text.data(using: .utf8),
                    let decoded = try? JSONDecoder().decode(FeedbackResponse.self, from: data)
                {
                    // 2. pull out the new field
                    expression = decoded.expression.lowercased()
                    feedback   = decoded.feedback
                    followUp   = decoded.followUp   // now holds "apa yang membuatmu sedih?"
                    
                } else {
                    // fallback
                    expression = "sedih"
                    feedback   = text
                    followUp   = ""
                    
                }
            } catch {
                promptLimit = promptLimit + 1
                feedback = "Error: \(error.localizedDescription)"
                followUp = ""
                expression = "sedih"
                
                print(error)
            }
        }
        
        
    }
    
}

#Preview {
    StoryView(emotionName: "senang")
}
