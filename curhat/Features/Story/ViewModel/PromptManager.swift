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
    @Published var logPrompts: [(user: String, modelResponse: String)] = []
    @Published var expression: String = "sedih"
    @Published var feedback: String = ""
    @Published var followUp: String = ""
    @Published var isLoading: Bool = false
    @Published var promptLimit: Int = 0
    
    // New property to store the previous follow-up question
    @Published var previousFollowUp: String = ""
    
    @AppStorage("userNickname") private var nickname: String = ""
    
    func generateResponse() {
        let fullPrompt = """
        
        Berikut log cerita user dan respons sebelumnya:
        \(logPrompts)

        Berikut ini adalah jawaban terbaru dari user:
        \(userPrompt)

        Nama user: \(nickname)
        Nama model (teman curhat): Mochi

        ---

        🎭 Peranmu:  
        Kamu adalah **teman curhat online** yang:
        - Supportive, bisa bikin user ngerasa aman buat cerita
        - Santai, tidak lebay atau berlebihan
        - Gunakan gaya bahasa yang biasa dipakai anak muda umur 18–25 tahun (bisa pakai lo/gue atau yang setara)
        - Bukan terapis atau orang dewasa yang menggurui — kamu cuma teman yang enak diajak ngobrol

        ---

        🧭 Panduan Obrolan:  
        Arahkan percakapan sesuai dengan tahapan **struktur curhat** berikut:

        1. **Exploration** → Gali dulu kejadiannya. Tanyakan: siapa, apa, kapan, kenapa, dan gimana perasaannya saat itu?  
        2. **Reflection** → Ajak mikir pelajaran atau makna dari kejadian itu.  
        3. **Regulation** → Ajak mikir langkah kecil atau keputusan yang bisa diambil setelahnya.

        ---

        📝 Tugasmu:

        - Analisis jawaban user dan tentukan ekspresi emosinya: hanya pilih salah satu dari **"senang"** atau **"sedih"**  
        - Buat satu **follow-up question** yang pendek, relevan, dan sesuai dengan tahapan struktur curhat (jangan diulang-ulang)  
        - Berikan **feedback singkat** yang hangat dan supportive, tapi gak lebay  
        - Kalau user terlihat tidak ingin bercerita lebih jauh, kamu boleh ganti topik yang masih relevan atau lanjut ke tahap berikutnya  
        - Kamu cuma boleh bertanya maksimal **10 kali** (jadi manfaatkan setiap pertanyaan dengan bijak)
        - Jangan terlalu panjang, cukup satu pertanyaan dan satu feedback

        ---
                       
        ⚠️ Jawab hanya dalam 1 objek JSON, contoh:
        {"expression":"senang","follow_up_question":"Apa …?","feedback":"Keren …"}
        JANGAN gunakan array untuk `expression`, dan JANGAN sertakan ```json fences```. PERHATIKAN JANGAN GUNAKAN ```json fences```.
        
        """
        
        isLoading   = true
        feedback = "..."
        followUp   = ""
        speechManager.stop()
        
        previousFollowUp = followUp
        
        self.promptLimit += 1
        
        Task {
            
            
            
            do {
                let result = try await model.generateContent(fullPrompt)
                let text   = result.text ?? ""
                
                if
                    let data = text.data(using: .utf8),
                    let decoded = try? JSONDecoder().decode(FeedbackResponse.self, from: data)
                {
                    DispatchQueue.main.async {
                        // Combine feedback and follow-up into a single string
                        let combinedResponse = "\(decoded.feedback) \(decoded.followUp)"
                        
                        // Store both user prompt and combined model response
                        self.logPrompts.append((user: self.userPrompt, modelResponse: combinedResponse))
                        // 2. pull out the new field
                        self.expression = decoded.expression.lowercased()
                        self.feedback   = decoded.feedback
                        self.followUp   = decoded.followUp
                        
                        // Reset previous follow-up since we got a new one
                        self.previousFollowUp = ""
                    }
                    
                } else {
                    // fallback
                    DispatchQueue.main.async {
                        // Use previous follow-up if available
                        let fallbackResponse = text.isEmpty ? self.previousFollowUp : text
                        
                        // Store both user prompt and model response
                        self.logPrompts.append((user: self.userPrompt, modelResponse: fallbackResponse))
                        
                        self.expression = "sedih"
                        self.feedback = text.isEmpty ? "Maaf, ada kendala. boleh ku tanya lagi" : text
                        
                        // Use previous follow-up if new follow-up is empty
                        self.followUp = fallbackResponse
                    }
                    
                }
            } catch {
                let errorMessage = "Error: \(error.localizedDescription)"
                
                // Use previous follow-up if available
                let fallbackFollowUp = self.previousFollowUp.isEmpty
                ? "Bagaimana perasaanmu sekarang?"
                : self.previousFollowUp
                
                self.feedback = "Maaf, ada kendala. boleh ku tanya lagi"
                self.followUp = fallbackFollowUp
                self.expression = "sedih"
                
                // Store error information
                self.logPrompts.append((user: self.userPrompt, modelResponse: "\(errorMessage) \(fallbackFollowUp)"))
                
                print(error)
            }
            
            DispatchQueue.main.async {
                do {
                    self.isLoading = false;
                    self.userPrompt = ""
                }
            }
        }
        
        
    }
}
