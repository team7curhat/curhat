import Foundation
import AVFoundation


final class SpeechManager: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    func speak(_ text: String) {
        // Guard clause: skip if `text` is empty
        guard !text.isEmpty else { return }
        
        // Create an utterance with the provided text
        let utterance = AVSpeechUtterance(string: text)
        
        // MARK: – Voice
        // Sets the voice language. Default is system locale voice.
        // Here we use Indonesian:
        //   language: "id-ID"
        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
        
        // MARK: – Rate
        // Speaking rate, from 0.0 (slowest) to 1.0 (fastest).
        // Default value: AVSpeechUtteranceDefaultSpeechRate (~0.5)
        // Customized here to be slightly slower for clarity:
        //   rate: 0.45
        utterance.rate = 0.35
        
        // MARK: – Pitch
        // Pitch multiplier, from 0.5 (lower) to 2.0 (higher).
        // Default value: 1.0 (neutral pitch)
        // Keeping normal pitch:
        //   pitchMultiplier: 1.0
        utterance.pitchMultiplier = 1.25
        
        // MARK: – Volume
        // Volume level, from 0.0 (silent) to 1.0 (full volume).
        // Default value: 1.0
        // Using full volume:
        //   volume: 1.0
        utterance.volume = 1.0
        
        // Finally, speak the utterance
        synthesizer.speak(utterance)
    }
    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}
