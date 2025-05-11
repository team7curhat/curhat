//
//  SpeechRecognizer.swift
//  curhat
//
//  Created by Sakti Pardano on 08/05/25.
//

import Foundation
import Speech

class SpeechRecognizer: ObservableObject {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "id-ID"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private var lastTranscript: String = ""
    @Published var transcribedText: String = ""
    @Published var audioLevel: Float = 0.0
    @Published var isRestartingAudio: Bool = false
    
    // A timer to restart the audio buffer
    var audioRestartTimer: Timer?
    // A Timer to offset the restart of the audiobuffer - we made it a timer so we can invalidate it in the event we just want to stop the audio.
    var startAudioIntervalTimer: Timer?
    // A time interval to restart you buffer
    let restartTimeInterval: TimeInterval = 20
    
    
    func startRecording() throws {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            // Handle authorization if needed
        }
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create request") }
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                
                DispatchQueue.main.async {
                    let newTranscript = result.bestTranscription.formattedString
//                    if !newTranscript.hasPrefix(self.lastTranscript) {
//                        self.lastTranscript = ""
//                    }
//                    
//                    let diff = self.diffTranscript(previous: self.lastTranscript, current: newTranscript)
//                    
//                    if !diff.isEmpty {
//                        self.transcribedText += " " + diff
//                        self.lastTranscript = newTranscript
//                    }
                    
//                     Only diff if new transcript is longer
                    if newTranscript.count > self.lastTranscript.count {
                        let diff = self.diffTranscript(previous: self.lastTranscript, current: newTranscript)
                        
                        if result.isFinal || diff.split(separator: " ").count > 2 {
                            self.transcribedText += " " + diff
                            self.lastTranscript = newTranscript
                        }
                    }
                }
            }
            if error != nil || (result?.isFinal ?? false) {
                inputNode.reset()
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func stopRecording() {
        
        if let timer = audioRestartTimer, timer.isValid {
            audioRestartTimer?.invalidate()
            audioRestartTimer = nil
        }
        
        if let timer = startAudioIntervalTimer, timer.isValid {
            startAudioIntervalTimer?.invalidate()
        }
        
        self.lastTranscript = ""
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        self.recognitionTask?.cancel()
        self.recognitionTask = nil
        self.recognitionRequest = nil
        self.audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    
    func restartAudioBuffer() {
        
        if audioEngine.isRunning {
            stopRecording()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                do {
                    try self.startRecording()
                    self.setRestartAudioBufferTimer()
                } catch {
                    print("Failed to restart audio buffer: \(error)")
                }
            }
        } else {
            do {
                try startRecording()
                self.setRestartAudioBufferTimer()
            } catch {
                print("Failed to restart audio buffer with error \(error)")
            }
        }
       
    }
    
    
//    func restartAudioBuffer() {
//        
//        if audioEngine.isRunning {
//            
//            self.stopRecording()
//            
//            
//            self.startAudioIntervalTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { timer in
//                timer.invalidate()
//                self.restartAudioBuffer()
//                self.isRestartingAudio.toggle()
//            })
//            
//        } else {
//            do {
//                try startRecording()
//                self.setRestartAudioBufferTimer()
//            } catch {
//                print("Failed to restart audio buffer with error \(error)")
//            }
//        }
//    }
    
    
    private func setRestartAudioBufferTimer() {
        
        if let timer = self.audioRestartTimer, timer.isValid {
            self.audioRestartTimer?.invalidate()
            self.audioRestartTimer = nil
        }
        
        self.audioRestartTimer = Timer.scheduledTimer(withTimeInterval: self.restartTimeInterval, repeats: false, block: { timer in
            timer.invalidate()
            self.restartAudioBuffer()
        })
    }
    
    func diffTranscript(previous: String, current: String) -> String {
        let prevWords = previous.split(separator: " ")
        let currWords = current.split(separator: " ")

        var i = 0
        while i < min(prevWords.count, currWords.count) {
            if prevWords[i] != currWords[i] {
                break
            }
            i += 1
        }

        // Only take the words that are new
        let diffWords = currWords.dropFirst(i)
        return diffWords.joined(separator: " ")
    }
    
    
    
}
