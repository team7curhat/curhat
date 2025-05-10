//
//  PromptManager.swift
//  curhat
//
//  Created by Sakti Pardano on 09/05/25.
//

import Foundation
import SwiftUI
import GoogleGenerativeAI

class PromptManager: ObservableObject, Sendable {
    
    @Published var speechManager = SpeechManager()
    let model = GeminiModel.shared.generativeModel
    
    @Published var userPrompt: String = ""
    @Published var logPrompts: [String] = []
    @Published var expression: String = "sedih"
    @Published var feedback: String = ""
    @Published var followUp: String = ""
    @Published var isLoading: Bool = false
    @Published var promptLimit: Int = 0
    
    
    @AppStorage("userNickname") private var nickname: String = ""
    
    
    func generateResponse() {
        let fullPrompt = """
        
        Nama user = \(nickname)
         
        jadilah teman curhat seperti persona ini:
                        - jadi pribadi yang supportive tetapi juga straight forward
                        - kamu bisa pakai bahasa untuk orang berusia 18-25 tahun
                          gunakan struktur percakapan curhat sebagai panduan dalam menyusun respons:
        
                        1. **Awareness**: tanyakan tentang emosi yang sedang dihadapi oleh user
                        2. **Exploration**: tanyakan tentang kejadian yang mencakup siapa, apa, di mana, kapan, mengapa, dan bagaimana tapi jangan ditanya lagi kalau sudah dijelaskan diawal terkait siapa, apa, di mana, kapan, mengapa, dan bagaimananya buat bahasanya seperti best friend yang sangat care terhadap apa yang ingin diceritakan.
                        3. **Reflection**: tanyakan kepada user apakah mereka bersedia untuk melakukan refleksi. Jika mereka setuju, bantu mereka mengeksplorasi pelajaran atau makna dari tahapan sebelumnya.
                        4. **Regulation**: tanyakan langkah apa yang akan mereka ambil setelah melakukan refleksi.
        
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
                        - maksimalkan 10 pertanyaan yang sesuai dengan **struktur curhat** untuk mendapatkan informasi apa, dimana, kapan, kenapa, siapa, bagaimana tapi jika sudah diceritakan dari beberapa informasi yang dibutuhkan kamu tidak perlu bertanya lagi.
        
        ⚠️ Jawab hanya dalam 1 objek JSON, contoh:
        {"expression":"senang","follow_up_question":"Apa …?","feedback":"Keren …"}
        JANGAN gunakan array untuk `expression`, dan JANGAN sertakan ```json fences```. PERHATIKAN JANGAN GUNAKAN ```json fences```.
        
        """
        
        isLoading   = true
        feedback = "..."
        followUp   = ""
        speechManager.stop()
        
        logPrompts.append(userPrompt)
        
        print(logPrompts)
        
        Task {
            
            DispatchQueue.main.async {
                do {
                    self.isLoading = false;
                    self.userPrompt = ""
                }
            }
           
            do {
                print("masuk")
                let result = try await model.generateContent(fullPrompt)
                let text   = result.text ?? ""
                DispatchQueue.main.async {
                    self.promptLimit += 1
                }
                print("Hasil: \(text)")
                if
                    let data = text.data(using: .utf8),
                    let decoded = try? JSONDecoder().decode(FeedbackResponse.self, from: data)
                {
                    DispatchQueue.main.async {
                        // 2. pull out the new field
                        self.expression = decoded.expression.lowercased()
                        self.feedback   = decoded.feedback
                        self.followUp   = decoded.followUp   // now holds "apa yang membuatmu sedih?"
                    }
                    
                } else {
                    // fallback
                    DispatchQueue.main.async {
                        self.expression = "sedih"
                        self.feedback   = text
                        self.followUp   = ""
                    }
                    
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
