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
    
//    func generateResponse() {
//        let fullPrompt = """
//        
//        Nama user = \(nickname)
//         
//        jadilah teman curhat seperti persona ini:
//                        - jadi pribadi yang supportive dan tidak lebay
//                        - kamu bisa pakai bahasa untuk orang berusia 18-25 tahun
//        
//                          gunakan struktur percakapan curhat sebagai panduan dalam menyusun respons:
//                        1. **Exploration**: tanyakan tentang kejadian yang mencakup siapa, apa, dimana, kapan, mengapa, dan bagaimana 
//                        2. **Reflection**: bantu mereka mengeksplorasi pelajaran atau makna dari tahapan sebelumnya.
//                        3. **Regulation**: tanyakan langkah apa yang akan mereka ambil setelah melakukan refleksi.
//        
//                        Berikut log cerita user, analisis dan jadikan log cerita ini acuan pertanyaan selanjutnya:
//                        \(logPrompts)
//        
//                        Berikut ini adalah jawaban dari user:
//                        \(userPrompt)
//                        
//                        Tugasmu:
//        
//                        - buat user merasa diperhatikan dengan menyebut namanya
//                        - Analisis teks user tersebut dan tentukan ekspresi emosinya (hanya satu dari: senang atau sedih).
//                        - Buatkan pertanyaan lanjutan (follow-up question) sesuai dengan tahap **struktur curhat** yang paling relevan saat ini.
//                        - Berikan feedback yang singkat maksimal 5 kata namun bermakna, sesuai dengan persona yang supportive dan tidak lebay.
//                        - runtutan setiap bertanya adalah berikan dia feedback dulu baru kamu boleh lanjut kasih pertanyaan.
//                        - jangan mengulang ulang pertanyaan sebelumnya
//                        - jika user tidak ingin bercerita, lanjutkan ke tahapan selanjutnya.
//                       
//        
//        ⚠️ Jawab hanya dalam 1 objek JSON, contoh:
//        {"expression":"senang","follow_up_question":"Apa …?","feedback":"Keren …"}
//        JANGAN gunakan array untuk `expression`, dan JANGAN sertakan ```json fences```. PERHATIKAN JANGAN GUNAKAN ```json fences```.
//        
//        """
//        
//        isLoading = true
//        feedback    = "..."
//        followUp    = ""
//        speechManager.stop()
//        
//        logPrompts.append(userPrompt)
//        
//        Task {
//            let startTime = Date()
//
//            // 1. Do your model call + JSON parsing + UI updates
//            do {
//                let result = try await model.generateContent(fullPrompt)
//                let text   = result.text ?? ""
//                
//                DispatchQueue.main.async {
//                    self.promptLimit += 1
//                    self.userPrompt = ""
//                }
//                
//                if
//                    let data    = text.data(using: .utf8),
//                    let decoded = try? JSONDecoder().decode(FeedbackResponse.self, from: data)
//                {
//                    DispatchQueue.main.async {
//                        self.expression = decoded.expression.lowercased()
//                        self.feedback   = decoded.feedback
//                        self.followUp   = decoded.followUp
//                    }
//                } else {
//                    // fallback if JSON decode fails
//                    DispatchQueue.main.async {
//                        self.expression = "sedih"
//                        self.feedback   = text
//                        self.followUp   = ""
//                    }
//                }
//                
//            } catch {
//                DispatchQueue.main.async {
//                    self.promptLimit += 1
//                    self.feedback     = "Error: \(error.localizedDescription)"
//                    self.expression   = "sedih"
//                    self.followUp     = ""
//                    self.userPrompt   = ""
//                }
//                print("⛔️ generateResponse error:", error)
//            }
//
//            // 2. Calculate elapsed and sleep to hit at least 0.75 s
//            let elapsed    = Date().timeIntervalSince(startTime)
//            let remaining  = max(0, 0.75 - elapsed)
//            if remaining > 0 {
//                try? await Task.sleep(nanoseconds: UInt64(remaining * 1_000_000_000))
//            }
//
//            // 3. Finally clear the loading state
//            DispatchQueue.main.async {
//                self.isLoading = false
//            }
//        }
//    }


    
    func generateResponse() {
        let fullPrompt = """
        
        Nama user = \(nickname)
         
        jadilah teman curhat seperti persona ini:
                        - jadi pribadi yang supportive dan tidak lebay
                        - kamu bisa pakai bahasa untuk orang berusia 18-25 tahun
        
                          gunakan struktur percakapan curhat sebagai panduan dalam menyusun respons:
                        1. **Exploration**: tanyakan tentang kejadian yang mencakup siapa, apa, dimana, kapan, mengapa, dan bagaimana 
                        2. **Reflection**: bantu mereka mengeksplorasi pelajaran atau makna dari tahapan sebelumnya.
                        3. **Regulation**: tanyakan langkah apa yang akan mereka ambil setelah melakukan refleksi.
        
                        Berikut log cerita user, analisis dan jadikan log cerita ini acuan pertanyaan selanjutnya:
                        \(logPrompts)
        
                        Berikut ini adalah jawaban dari user:
                        \(userPrompt)
                        
                        Tugasmu:
        
                        - Analisis teks user tersebut dan tentukan ekspresi emosinya (hanya satu dari: senang atau sedih).
                        - Buatkan pertanyaan lanjutan (follow-up question) sesuai dengan tahap **struktur curhat** yang paling relevan saat ini.
                        - Berikan feedback yang singkat maksimal 5 kata namun bermakna, sesuai dengan persona yang supportive dan tidak lebay.
                        - runtutan setiap bertanya adalah berikan dia feedback dulu baru kamu boleh lanjut kasih pertanyaan.
                        - jangan mengulang ulang pertanyaan sebelumnya
                        - jika user tidak ingin bercerita, lanjutkan ke tahapan selanjutnya.
                       
        
        ⚠️ Jawab hanya dalam 1 objek JSON, contoh:
        {"expression":"senang","follow_up_question":"Apa …?","feedback":"Keren …"}
        JANGAN gunakan array untuk `expression`, dan JANGAN sertakan ```json fences```. PERHATIKAN JANGAN GUNAKAN ```json fences```.
        
        """
        
        isLoading   = true
        feedback = "..."
        followUp   = ""
        speechManager.stop()
        
        logPrompts.append(userPrompt)
        
        self.promptLimit += 1
        print(" masuk")
        
        Task {
            
            
           
            do {
                let result = try await model.generateContent(fullPrompt)
                let text   = result.text ?? ""
                
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
                feedback = "Error: \(error.localizedDescription)"
                followUp = ""
                expression = "sedih"
                
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
