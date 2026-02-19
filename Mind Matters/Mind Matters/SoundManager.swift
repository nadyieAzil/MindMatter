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
        // Pre-load sounds if files exist
        for type in [SoundType.buttonClick, .waterPop, .sandBrush, .paperUnroll] {
            if let path = Bundle.main.path(forResource: type.rawValue, ofType: "mp3") {
                let url = URL(fileURLWithPath: path)
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    player.prepareToPlay()
                    players[type] = player
                } catch {
                    print("Error loading sound \(type.rawValue): \(error)")
                }
            }
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
