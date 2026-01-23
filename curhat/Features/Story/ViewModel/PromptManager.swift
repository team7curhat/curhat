//
//  PromptManager.swift
//  curhat
//
//  Created by Sakti Pardano on 09/05/25.
//


import SwiftUI


@MainActor
final class PromptManager: ObservableObject {
    
    @Published var speechManager = SpeechManager()
    
    @Published var userPrompt: String = ""
    @Published var logPrompts: [(user: String, modelResponse: String)] = []
    @Published var expression: String = "sedih"
    @Published var feedback: String = ""
    @Published var followUp: String = ""
    @Published var isLoading: Bool = false
    @Published var promptLimit: Int = 0
    @Published var previousFollowUp: String = ""
    
    @AppStorage("userNickname") private var nickname: String = ""
    
    func generateResponse() {
        
        guard !userPrompt.isEmpty else { return }
        
        let fullPrompt = """
        Here are the user story logs and previous responses:
        \(logPrompts)

        Your name is : Mochi
        """
        
        isLoading = true
        feedback = "..."
        followUp = ""
        speechManager.stop()
        previousFollowUp = followUp
        promptLimit += 1
        
        Task {
            do {
                let request = GenerateRequest(
                    logPrompts: fullPrompt,
                    userPrompt: userPrompt,
                    nickname: nickname
                )
                let response = try await APIService.shared.generateResponse(generateRequest: request)
                
                // Use the response
                print(response.expression)
                print(response.follow_up_question)
                print(response.feedback)
                
                self.expression = response.expression
                self.followUp = response.follow_up_question
                self.feedback = response.feedback
                
                self.logPrompts.append(
                    (user: self.userPrompt, modelResponse: response.feedback)
                )
                
                self.userPrompt = ""
            } catch {
                self.feedback = "Something went wrong. Please try again."
                print("Error: \(error)")
            }
        }
        
    }
    
    func reloadQuestions(){
        let fullPrompt = """
        
        Here are the user story logs and previous responses:
        \(logPrompts)

        Here are the latest answers from users:
        \(userPrompt)

        User name: \(nickname)
        Your name is : Mochi

        ---

        🎭 Your role:  
              You are the **online confidant**:
              - Supportive, can make users feel safe to share their stories.
              - Casual, not overbearing or exaggerated
              - Use the language style commonly used by young people aged 18-25
              - Not a therapist or a patronizing adult - you're just a friend who's fun to talk to

        ---

        🧭 Chat Guide:  
              Direct the conversation according to the following stages of the **confide structure**:

              1. **Exploration** → Dig into what happened first. Ask: who, what, when, why, and how did she feel at the time?
              2. **Reflection** → Encourage thinking about the lesson or meaning of the incident.
              3. **Regulation** → Encourage thinking of small steps or decisions that can be taken afterwards.

        ---

        📝 Your task:

           - Analyze the user's answers and determine their emotional expression: only choose one of **“happy”** or **“sad”**.
           - Create one **follow-up question** that is short, relevant, and fits the stage of the vent structure (don't repeat it)
           - Give a short **feedback** that is warm and supportive, but not overly so
           - If the user doesn't seem to want to talk further, you can change the topic or move on to the next stage.
           - You can only ask a maximum of **10 questions** (so utilize each question wisely)
           - Don't be too long, just one question and one feedback

        ---
                       
        ⚠️ Answer only in 1 JSON object, example:
             {"expression": "happy", "follow_up_question": "What...?", "feedback": "Cool..."}
             DO NOT use arrays for `expression`, and DO NOT include ``json fences``. PLEASE DO NOT USE ``json fences``.
        """
        
        isLoading   = true
        feedback = "..."
        followUp   = ""
        speechManager.stop()
        
        Task {
            
            
           
            
            DispatchQueue.main.async {
                do {
                    self.isLoading = false;
                    self.userPrompt = ""
                }
            }
        }

    }
}

    

