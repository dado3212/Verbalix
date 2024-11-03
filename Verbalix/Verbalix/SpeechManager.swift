//
//  SpeechManager.swift
//  Verbalix
//
//  Created by Alex Beals on 10/22/24.
//

import AVFoundation

class SpeechManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
  private let synthesizer = AVSpeechSynthesizer()
  let voices = AVSpeechSynthesisVoice.speechVoices()
  var voiceToUse: AVSpeechSynthesisVoice?
  private let audioSession = AVAudioSession.sharedInstance()

  override init() {
    super.init()

      // Pick the preferred voice, default to en-US if no enhanced or premium voice found
      voiceToUse = AVSpeechSynthesisVoice(language: "en-US")
      for voice in voices {
          if (voice.quality == .enhanced || voice.quality == .premium) && voice.language == "en-US" {
              voiceToUse = voice
          }
      }
    synthesizer.delegate = self
  }
  
  func configureAudioSessionForDucking() {
          let audioSession = AVAudioSession.sharedInstance()
          do {
              try audioSession.setCategory(.playback, options: [.duckOthers])
              try audioSession.setActive(true)
          } catch {
              print("Failed to set audio session category: \(error)")
          }
      }

    func speak(text: String) {
      configureAudioSessionForDucking()
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voiceToUse
        
        synthesizer.speak(utterance)
    }
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
          do {
              try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
          } catch {
              print("Failed to deactivate audio session: \(error)")
          }
      }
}
