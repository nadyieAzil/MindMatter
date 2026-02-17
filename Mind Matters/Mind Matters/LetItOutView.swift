import SwiftUI

struct LetItOutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""
    @State private var isReleasing: Bool = false
    @State private var currentQuestion: String = "Let everything out of your mind"
    @State private var showQuestions: Bool = false
    
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
            
            Color.white.opacity(0.1)
                .background(.ultraThinMaterial.opacity(0.3))
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Question Area
                VStack(spacing: 20) {
                    Text(currentQuestion)
                        .font(.system(size: 32, weight: .thin, design: .serif))
                        .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 60)
                        .id(currentQuestion)
                        .transition(.opacity)

                    Button(action: {
                        withAnimation(.spring()) {
                            currentQuestion = questions.randomElement() ?? questions[0]
                            showQuestions = true
                        }
                    }) {
                        Label("Get Random Question", systemImage: "sparkles")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 28)
                            .background(
                                Capsule()
                                    .fill(Color(red: 0.5, green: 0.7, blue: 0.9))
                            )
                            .shadow(color: .blue.opacity(0.15), radius: 10, x: 0, y: 5)
                    }
                }
                .padding(.top, 40)

                // Paper Input Area
                ZStack {
                    if !isReleasing {
                        TextEditor(text: $text)
                            .font(.system(size: 22, design: .serif))
                            .lineSpacing(10)
                            .scrollContentBackground(.hidden)
                            .padding(60)
                            .frame(maxWidth: 800, maxHeight: 750)
                            .background(
                                PaperView()
                                    .shadow(color: .black.opacity(0.1), radius: 30, x: 0, y: 20)
                            )
                            .transition(.asymmetric(
                                insertion: .opacity,
                                removal: .modifier(
                                    active: FoldAndThrowModifier(progress: 1.0),
                                    identity: FoldAndThrowModifier(progress: 0.0)
                                )
                            ))
                    }
                }
                .padding(.vertical, 40)

                // Release Button
                Button(action: releaseConfession) {
                    Text("Release Thoughts")
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .frame(width: 260, height: 64)
                        .background(
                            ZStack {
                                Capsule()
                                    .fill(text.isEmpty ? Color.gray.opacity(0.4) : Color(red: 0.4, green: 0.6, blue: 0.8))
                                if !text.isEmpty {
                                    Capsule()
                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                }
                            }
                        )
                        .shadow(color: text.isEmpty ? .clear : .blue.opacity(0.3), radius: 20, x: 0, y: 10)
                }
                .disabled(text.isEmpty || isReleasing)
                .padding(.bottom, 60)
                
                // Digital Trash Bin Indicator
                if isReleasing {
                    Image(systemName: "trash.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5).opacity(0.2))
                        .transition(.scale.combined(with: .opacity))
                        .offset(y: -40)
                } else {
                    Color.clear.frame(height: 80)
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
        .safeAreaInset(edge: .top) {
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                        Text("Back to Main Page")
                    }
                    .font(.headline)
                    .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(.ultraThinMaterial)
                    .cornerRadius(30)
                    .shadow(color: .black.opacity(0.1), radius: 10)
                }
                Spacer()
            }
            .padding(.leading, 30)
            .padding(.top, 20)
        }
    }
    
    private func releaseConfession() {
        withAnimation(.easeInOut(duration: 2.0)) {
            isReleasing = true
        }
        
        // Reset after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            text = ""
            isReleasing = false
            currentQuestion = "Let everything out of your mind"
            showQuestions = false
        }
    }
}

// Geometric "Paper" background
struct PaperView: View {
    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size)
            context.fill(Path(rect), with: .color(Color(red: 0.99, green: 0.99, blue: 0.98)))
            
            // Subtle horizontal lines
            for i in 1...20 {
                let y = CGFloat(i) * 38
                var path = Path()
                path.move(to: CGPoint(x: 40, y: y))
                path.addLine(to: CGPoint(x: size.width - 40, y: y))
                context.stroke(path, with: .color(Color.blue.opacity(0.03)), lineWidth: 1)
            }
            
            // Vertical margin line
            var sideline = Path()
            sideline.move(to: CGPoint(x: 90, y: 0))
            sideline.addLine(to: CGPoint(x: 90, y: size.height))
            context.stroke(sideline, with: .color(Color.red.opacity(0.06)), lineWidth: 1.5)
        }
        .cornerRadius(12)
    }
}

// Custom Geometry Modifier for "Fold and Throw" Effect
struct FoldAndThrowModifier: ViewModifier {
    var progress: CGFloat
    
    func body(content: Content) -> some View {
        // folding: 0.0 -> 0.5
        // throwing: 0.5 -> 1.0
        let foldProgress = min(1.0, progress / 0.5)
        let throwProgress = max(0.0, (progress - 0.5) / 0.5)
        
        content
            // Phase 1: Fold (Scaling X significantly then Y)
            .scaleEffect(x: 1.0 - (foldProgress * 0.9), y: 1.0 - (foldProgress * 0.85))
            .rotation3DEffect(.degrees(foldProgress * 60), axis: (x: 1, y: 0.2, z: 0))
            
            // Phase 2: Throw
            .rotationEffect(.degrees(throwProgress * 1500))
            .offset(y: throwProgress * 1500)
            .scaleEffect(1.0 - (throwProgress * 0.95))
            .opacity(1.0 - throwProgress)
            .blur(radius: throwProgress * 8)
    }
}

#Preview {
    LetItOutView()
}

#Preview {
    LetItOutView()
}
