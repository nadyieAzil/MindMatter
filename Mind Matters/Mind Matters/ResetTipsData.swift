import Foundation
import SwiftUI

struct Technique: Identifiable {
    let id = UUID()
    let title: String
    let whyItHelps: String
    let steps: [String]
}

struct EmotionTips: Identifiable {
    let id = UUID()
    let emoji: String
    let name: String
    let validation: String
    let techniques: [Technique]
    let color: Color
}

struct ResetTipsData {
    static let emotions: [EmotionTips] = [
        EmotionTips(
            emoji: "😠",
            name: "Angry",
            validation: "It's okay to feel angry. Let's slow it down.",
            techniques: [
                Technique(
                    title: "4-7-8 Breathing",
                    whyItHelps: "Helps slow your nervous system.",
                    steps: [
                        "Inhale for 4 seconds",
                        "Hold for 7 seconds",
                        "Exhale for 8 seconds",
                        "Repeat 4 times"
                    ]
                ),
                Technique(
                    title: "10-Minute Rule",
                    whyItHelps: "Prevents impulsive reactions.",
                    steps: [
                        "Do not respond immediately",
                        "Step away physically if possible",
                        "Set a 10-minute timer",
                        "Revisit the situation calmly"
                    ]
                ),
                Technique(
                    title: "Cold Water Reset",
                    whyItHelps: "Physically interrupts anger spike.",
                    steps: [
                        "Splash cold water on your face",
                        "Hold breath for 10 seconds",
                        "Take one deep inhale"
                    ]
                )
            ],
            color: Color(red: 1.0, green: 0.8, blue: 0.8) // Soft red/pink
        ),
        EmotionTips(
            emoji: "😰",
            name: "Anxious",
            validation: "Your body feels unsafe. Let's calm it.",
            techniques: [
                Technique(
                    title: "Box Breathing",
                    whyItHelps: "Restores a sense of control over your rhythm.",
                    steps: [
                        "Inhale 4",
                        "Hold 4",
                        "Exhale 4",
                        "Hold 4",
                        "Repeat 6 times"
                    ]
                ),
                Technique(
                    title: "Progressive Muscle Relaxation",
                    whyItHelps: "Physically releases the tension of anxiety.",
                    steps: [
                        "Tighten fists for 5 seconds",
                        "Release",
                        "Move to shoulders",
                        "Release",
                        "Continue downward"
                    ]
                ),
                Technique(
                    title: "Counting Backwards",
                    whyItHelps: "Forces your brain to switch from emotion to logic.",
                    steps: [
                        "Start at 100",
                        "Subtract 3 each time",
                        "Focus fully on numbers"
                    ]
                )
            ],
            color: Color(red: 0.8, green: 0.9, blue: 1.0) // Soft blue
        ),
        EmotionTips(
            emoji: "🤯",
            name: "Overthinking",
            validation: "Your mind is running fast. Let's ground it.",
            techniques: [
                Technique(
                    title: "Worst-Case Reflection",
                    whyItHelps: "Reduces exaggerated fear.",
                    steps: [
                        "Write the worst-case scenario",
                        "Ask: 'How likely is this?'",
                        "Ask: 'Can I handle it if it happens?'"
                    ]
                ),
                Technique(
                    title: "1-Year Question",
                    whyItHelps: "Creates perspective.",
                    steps: [
                        "Ask: 'Will this matter in one year?'",
                        "If no → release it.",
                        "If yes → plan one small action."
                    ]
                ),
                Technique(
                    title: "5-4-3-2-1 Grounding",
                    whyItHelps: "Brings attention to present.",
                    steps: [
                        "5 things you see",
                        "4 things you feel",
                        "3 things you hear",
                        "2 things you smell",
                        "1 thing you taste"
                    ]
                )
            ],
            color: Color(red: 0.9, green: 0.8, blue: 1.0) // Soft purple
        ),
        EmotionTips(
            emoji: "😔",
            name: "Sad",
            validation: "It's okay to feel heavy.",
            techniques: [
                Technique(
                    title: "Small Gratitude",
                    whyItHelps: "Gently shifts focus to small comforts.",
                    steps: [
                        "Identify one thing you are thankful for",
                        "Notice the feeling in your body",
                        "Hold that thought for 30 seconds"
                    ]
                ),
                Technique(
                    title: "5-Minute Outside",
                    whyItHelps: "Change of environment can reset mood.",
                    steps: [
                        "Step outside or open a window",
                        "Notice the temperature",
                        "Take 3 deep breaths of fresh air"
                    ]
                ),
                Technique(
                    title: "Safe Connection",
                    whyItHelps: "Bridges the isolation of sadness.",
                    steps: [
                        "Identify one safe person",
                        "Send a brief text or emoji",
                        "Allow yourself to be seen"
                    ]
                )
            ],
            color: Color(red: 0.8, green: 0.8, blue: 1.0) // Soft deep blue
        ),
        EmotionTips(
            emoji: "😵",
            name: "Overwhelmed",
            validation: "You have too much at once.",
            techniques: [
                Technique(
                    title: "Brain Dump List",
                    whyItHelps: "Gets the noise out of your head.",
                    steps: [
                        "Write everything you're thinking about",
                        "Don't worry about order",
                        "Seeing it on paper makes it finite"
                    ]
                ),
                Technique(
                    title: "Pick ONE Task",
                    whyItHelps: "Combats paralysis by focusing on simplicity.",
                    steps: [
                        "Select the easiest task",
                        "Ignore everything else for now",
                        "Do just that one thing"
                    ]
                ),
                Technique(
                    title: "5-Minute Start Rule",
                    whyItHelps: "Reduces the intimidation of starting.",
                    steps: [
                        "Promise yourself you'll stop in 5 mins",
                        "Begin the first step",
                        "Stop or continue—the choice is yours"
                    ]
                )
            ],
            color: Color(red: 1.0, green: 1.0, blue: 0.8) // Soft yellow
        ),
        EmotionTips(
            emoji: "😐",
            name: "Mentally Drained",
            validation: "You are tired, not broken.",
            techniques: [
                Technique(
                    title: "20-Minute Nap",
                    whyItHelps: "Short rest can clear brain fog.",
                    steps: [
                        "Find a quiet space",
                        "Set an alarm for 20 minutes",
                        "Close your eyes and just be"
                    ]
                ),
                Technique(
                    title: "Digital Detox",
                    whyItHelps: "Reduces sensory input and decision fatigue.",
                    steps: [
                        "Put your phone in another room",
                        "Turn off all screens",
                        "Sit in silence for 30 minutes"
                    ]
                ),
                Technique(
                    title: "Water + Breathing",
                    whyItHelps: "Hydrates your brain and oxygenates your blood.",
                    steps: [
                        "Drink a full glass of water",
                        "Take 5 slow, deep breaths",
                        "Feel the sensation of the water"
                    ]
                )
            ],
            color: Color(red: 0.9, green: 0.9, blue: 0.9) // Soft gray
        )
    ]
}
