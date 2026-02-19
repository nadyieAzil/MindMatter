import AVFoundation
import UIKit

enum SoundType: String {
    case buttonClick = "button_sound"
    case waterPop = "water_pop"
    case sandBrush = "sand_sound"
    case paperUnroll = "paper_sound"
}

class SoundManager {
    static let instance = SoundManager()
    private var players: [SoundType: AVAudioPlayer] = [:]
    
    private init() {
        configureAudioSession()
        preloadSounds()
    }
    
    private func configureAudioSession() {
        do {
            // .playback ensures sound plays even if physical mute switch is ON
            // .mixWithOthers allows other music (like Spotify) to keep playing
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            print("🔊 Audio Session configured successfully")
        } catch {
            print("❌ Failed to set up AVAudioSession: \(error)")
        }
    }
    
    private func preloadSounds() {
        print("🔍 Checking for sound assets in Bundle.main...")
        for type in [SoundType.buttonClick, .waterPop, .sandBrush, .paperUnroll] {
            loadSound(type)
        }
    }
    
    private func loadSound(_ type: SoundType) {
        if let path = Bundle.main.path(forResource: type.rawValue, ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                players[type] = player
                print("✅ Successfully loaded: \(type.rawValue).mp3")
            } catch {
                print("❌ Error initializing player for \(type.rawValue): \(error)")
            }
        } else {
            print("⚠️ Sound file NOT found in bundle: \(type.rawValue).mp3")
        }
    }
    
    func playSound(_ type: SoundType, volume: Float = 0.5) {
        // 1. Play Audio if available
        if let player = players[type] {
            player.volume = volume
            if player.isPlaying {
                player.currentTime = 0
            }
            player.play()
        }
        
        // 2. Pair with Haptics for tactile depth
        triggerHaptic(for: type)
    }
    
    private func triggerHaptic(for type: SoundType) {
        switch type {
        case .buttonClick:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .waterPop:
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred(intensity: 0.6)
        case .sandBrush:
            // Sand uses a continuous light feel if called repeatedly
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred(intensity: 0.3)
        case .paperUnroll:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred(intensity: 0.4)
        }
    }
}
