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
    @State var isActive : Bool = false
    // MARK: - Model
    let model = GeminiModel.shared.generativeModel
    
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
    @State private var expression: String = "netral"    // default image
    @State private var feedback: String = "Apa yang sedang kamu alami hari ini?"// feedback text
    @State private var followUp: String = ""            // follow-up question
    
    // MARK: - Confirmation Dialog Content
    private let confirmationDialogTitle: String = "Confirmation Dialog Title"
    private var confirmationDialogMessage: String = ""
    
    // MARK: - Speech Manager
    @StateObject private var speechManager = SpeechManager()
    
    // <-- new state for navigation
    @State private var shouldNavigate = false
    
    @State private var keyboardHeight: CGFloat = 0
    
    @State private var hasKeyboardShown: Bool = false
    
    var body: some View {
        NavigationView{
            
            VStack{
                
                
                
                if(hasKeyboardShown){
                    
                    HStack(alignment: .top, spacing:0){
                        Image("emochi-duduk")
                        BubbleChatView(message: feedback, isKeyboardActive: hasKeyboardShown)
                    }
                    .padding(.bottom, 8)
                    
                    Rectangle()
                        .fill(Color(.gray.opacity(0.2)))
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                }else{
                    Spacer(minLength: isTextFieldFocused ? 0 : 120 )
                    VStack{
                        
                        BubbleChatView(message: feedback, isKeyboardActive: hasKeyboardShown)
                        Image("takut")
                        
                        
                        ZStack {
                            
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                                    .scaleEffect(2)
                            }
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
                                            }
                                        }
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
                        Circle()
                            .fill(isTextFieldFocused ? Color("primary-3") : Color.white)
                            .frame(width: 56, height: 56)
                            .overlay(
                                Circle()
                                    .stroke(Color("primary-3"), lineWidth: 2)
                            )
                            .overlay(
                                Image(systemName: isTextFieldFocused ? "keyboard.fill" : "keyboard")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 21, height: 21)
                                    .foregroundColor(isTextFieldFocused ? .white : Color("primary-3"))
                            )
                            .onTapGesture {
                                hasKeyboardShown = true
                                isTextFieldFocused.toggle()
                                
                              
                            }
                        
                        Circle()
                            .fill(isMicActive ? Color("primary-3") : Color.white)
                            .frame(width: 56, height: 56)
                            .overlay(
                                Circle()
                                    .stroke(Color("primary-3"), lineWidth: 2)
                            )
                            .overlay(
                                Image(systemName: isMicActive ? "microphone.fill" : "microphone")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 21, height: 21)
                                    .foregroundColor(isMicActive ? .white : Color("primary-3"))
                            )
                            .onTapGesture {
                                isMicActive.toggle()
                            }

                    }

                }
                
                
                
            }.padding(.horizontal)
                .toolbar{
                    ToolbarItem{
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
                    ToolbarItem{
                        Button(action: {
                            showingConfirmationDialog = true
                        }){
                            Text("Selesai").font(.body).fontWeight(.semibold)
                        }.confirmationDialog(Text(confirmationDialogTitle),
                                             isPresented: $showingConfirmationDialog,
                                             titleVisibility: .automatic,
                                             actions: {
                            Button("Discard", role: .destructive) { }
                            Button("Summary") { }
                            Button("Cancel", role: .cancel) { }
                        },
                                             message: {
                            confirmationDialogMessage == "" ? nil : Text(confirmationDialogMessage)
                        }
                        )
                    }
                }
                .onChange(of: promptLimit) { newValue in
                    if newValue >= 3 {
                        promptLimit = 0
                        logPrompts.removeAll()
                        shouldNavigate = true
                    }
                }
            // hidden link that actually does the navigation
                .background(
                    NavigationLink(
                        destination: LoadingSummaryView(rootIsActive: self.$isActive, logPrompts: logPrompts),      // <-- the view you want to go to
                        isActive: $shouldNavigate,
                        label: { EmptyView() }
                    )
                    .isDetailLink(false)
                    .hidden()
                )
            
        }
    }
    
    
    func generateResponse() {
        let fullPrompt = """
        jadilah chatbot seperti persona ini:
        jadi pribadi yang supportive tetapi juga straight forward
        
        gunakan struktur percakapan curhat sebagai panduan dalam menyusun respons:
        1. **Awareness**: tanyakan tentang emosi yang sedang dihadapi oleh user.
        2. **Exploration**: tanyakan tentang kejadian yang mencakup siapa, apa, di mana, kapan, mengapa, dan bagaimana.
        3. **Reflection**: tanyakan kepada user apakah mereka bersedia untuk melakukan refleksi. Jika mereka setuju, bantu mereka mengeksplorasi pelajaran atau makna dari tahapan sebelumnya.
        4. **Regulation**: tanyakan langkah apa yang akan mereka ambil setelah melakukan refleksi.
        
        Berikut log cerita user:
        \(logPrompts)
        
        Berikut ini adalah jawaban dari user:
        \(userPrompt)
        
        Tugasmu:
        - Analisis teks user tersebut dan tentukan ekspresi emosinya (hanya satu dari: senang, netral, atau sedih).
        - Buatkan pertanyaan lanjutan (follow-up question) sesuai dengan tahap **struktur curhat** yang paling relevan saat ini.
        - Berikan feedback yang singkat namun bermakna, sesuai dengan persona yang supportive dan straight forward.
        - tanyakan hanya dua pertanyaan setelah itu berikan summary percakapannya
        
        ⚠️ Jawab hanya dalam 1 objek JSON, contoh:
        {"expression":"senang","follow_up_question":"Apa …?","feedback":"Keren …"}
        JANGAN gunakan array untuk `expression`, dan JANGAN sertakan ```json fences```.
        
        """
        
        isLoading   = true
        
        speechManager.stop()
        
        logPrompts.append(userPrompt)
        
        print(logPrompts)
        
        Task {
            defer { isLoading = false; userPrompt = "" }
            do {
                print("masuk")
                expression = "netral"
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
                    expression = "netral"
                    feedback   = text
                    followUp   = ""
                    
                }
            } catch {
                promptLimit = promptLimit + 1
                feedback = "Error: \(error.localizedDescription)"
                followUp = ""
                expression = "senang"
                
                print(error)
            }
        }
        
        
    }
    
}

#Preview {
    StoryView()
}
