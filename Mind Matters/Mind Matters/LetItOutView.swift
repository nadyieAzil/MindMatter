import SwiftUI

struct LetItOutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""
    @State private var isIsReleasing: Bool = false
    @State private var currentQuestion: String = "What is bothering you right now?"
    
    // 50 Deep Emotional Reflections
    private let questions = [
        "What is bothering you right now?",
        "What are you overthinking?",
        "What are you afraid to say out loud?",
        "What is one thing you wish people understood about you?",
        "What was the hardest part of your day?",
        "Is there a conversation you're avoiding? Why?",
        "What do you need to forgive yourself for?",
        "What is a secret you're tired of keeping?",
        "When did you last feel truly seen?",
        "What are you holding onto that no longer serves you?",
        "What is your biggest regret from this past week?",
        "What part of your future scares you the most?",
        "If you could change one decision you made, what would it be?",
        "What does \"peace\" feel like to you right now?",
        "Who do you miss, even if they're still in your life?",
        "What is a \"what if\" that keeps you up at night?",
        "What are you forcing yourself to do that you hate?",
        "What is the kindest thing you haven't said to someone yet?",
        "What are you mourning right now?",
        "What is a dream you've given up on?",
        "What makes you feel small?",
        "When do you feel most alone?",
        "What mask are you wearing today?",
        "What is a truth you're running away from?",
        "What is the one thing you're most proud of today?",
        "What do you wish you could say to your younger self?",
        "What is a burden you're tired of carrying?",
        "What does your inner critic keep telling you?",
        "What is something you've never told anyone?",
        "What are you most grateful for in this moment?",
        "What is a fear you're ready to let go of?",
        "What is a habit you're trying to break?",
        "What is a boundary you need to set?",
        "What is a question you're afraid to ask?",
        "What is a lesson you've learned recently?",
        "What is a memory that still brings you pain?",
        "What is a hope you're afraid to share?",
        "What is a part of yourself you're still learning to love?",
        "What is a regret you're still carrying?",
        "What is a need you're not expressing?",
        "What is a desire you're suppressing?",
        "What is a feeling you're avoiding?",
        "What is a thought you're judging?",
        "What is a belief that is limiting you?",
        "What is a pattern you're noticing in your life?",
        "What is a choice you're struggling to make?",
        "What is a change you're resisting?",
        "What is a truth you're finally accepting?",
        "What is a dream you're finally chasing?",
        "What is a part of your life that feels out of alignment?"
    ]

    var body: some View {
        ZStack {
            // Background
            Image("WelcomeWallpaper")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            Color.white.opacity(0.2)
                .background(.ultraThinMaterial.opacity(0.4))
                .ignoresSafeArea()

            VStack(spacing: 30) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.headline)
                        .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                    }
                    Spacer()
                    
                    Text("Let It Out")
                        .font(.system(size: 32, weight: .thin, design: .serif))
                        .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                    
                    Spacer()
                    
                    // Empty spacer to center title
                    Color.clear.frame(width: 80, height: 1)
                }
                .padding(.horizontal)

                Spacer()

                // Question Area
                VStack(spacing: 20) {
                    Text(currentQuestion)
                        .font(.title2)
                        .fontWeight(.light)
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .transition(.opacity)
                        .id(currentQuestion)

                    Button(action: {
                        withAnimation {
                            currentQuestion = questions.randomElement() ?? questions[0]
                        }
                    }) {
                        Text("Get Random Question")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(Color(red: 0.5, green: 0.7, blue: 0.9))
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }
                }

                // Paper Input Area
                ZStack {
                    if !isIsReleasing {
                        TextEditor(text: $text)
                            .font(.system(size: 20, design: .serif))
                            .scrollContentBackground(.hidden)
                            .padding(40)
                            .frame(maxWidth: 700, maxHeight: 500)
                            .background(
                                PaperView()
                                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                            )
                            .transition(.asymmetric(
                                insertion: .identity,
                                removal: .modifier(
                                    active: CrumpleModifier(progress: 1.0),
                                    identity: CrumpleModifier(progress: 0.0)
                                )
                            ))
                    }
                }
                .padding()

                // Release Button
                Button(action: releaseConfession) {
                    Text("Release")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 60)
                        .background(
                            Capsule()
                                .fill(text.isEmpty ? Color.gray.opacity(0.5) : Color(red: 0.4, green: 0.6, blue: 0.8))
                        )
                        .shadow(radius: 10)
                }
                .disabled(text.isEmpty || isIsReleasing)
                .opacity(text.isEmpty ? 0.6 : 1.0)
                
                Spacer()
                
                // Digital Trash Bin (Visible during release)
                if isIsReleasing {
                    Image(systemName: "trash")
                        .font(.system(size: 40))
                        .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5).opacity(0.5))
                        .padding(.bottom, 20)
                } else {
                    Color.clear.frame(height: 60)
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
    
    private func releaseConfession() {
        withAnimation(.easeInOut(duration: 1.5)) {
            isIsReleasing = true
        }
        
        // Reset after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            text = ""
            isIsReleasing = false
            currentQuestion = questions.randomElement() ?? questions[0]
        }
    }
}

// Geometric "Paper" background
struct PaperView: View {
    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size)
            context.fill(Path(rect), with: .color(Color(red: 0.98, green: 0.98, blue: 0.95)))
            
            // Subtle lines
            for i in 1...15 {
                let y = CGFloat(i) * 35
                var path = Path()
                path.move(to: CGPoint(x: 20, y: y))
                path.addLine(to: CGPoint(x: size.width - 20, y: y))
                context.stroke(path, with: .color(Color.blue.opacity(0.05)), lineWidth: 1)
            }
            
            // Sideline
            var sideline = Path()
            sideline.move(to: CGPoint(x: 60, y: 0))
            sideline.addLine(to: CGPoint(x: 60, y: size.height))
            context.stroke(sideline, with: .color(Color.red.opacity(0.1)), lineWidth: 1)
        }
        .cornerRadius(5)
    }
}

// Custom Geometry Modifier for Crumple Effect
struct CrumpleModifier: ViewModifier {
    var progress: CGFloat
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(1.0 - (progress * 0.9))
            .rotationEffect(.degrees(progress * 720))
            .offset(y: progress * 800)
            .opacity(1.0 - progress)
            .blur(radius: progress * 10)
    }
}

#Preview {
    LetItOutView()
}
