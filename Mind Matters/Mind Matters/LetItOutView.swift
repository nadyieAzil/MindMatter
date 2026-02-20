import SwiftUI

struct LetItOutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""
    @State private var isReleasing: Bool = false
    @State private var currentQuestion: String = "Let everything out of your mind"
    @State private var showResetTips: Bool = false
    
    var body: some View {
        ZStack {
            // Background
            GeometryReader { geometry in
                Image("WelcomeWallpaper")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header Space (Reserved for back button)
                Color.clear.frame(height: 70)

                Spacer()

                // Question Area
                VStack(spacing: 16) {
                    Text(currentQuestion)
                        .font(.system(size: 28, weight: .thin, design: .serif))
                        .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .id(currentQuestion)
                        .transition(.opacity)

                    Button(action: {
                        SoundManager.instance.playSound(.buttonClick)
                        withAnimation(.spring()) {
                            currentQuestion = ReflectionQuestions.all.randomElement() ?? ""
                        }
                    }) {
                        Label("Get Random Question", systemImage: "sparkles")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 22)
                            .background(
                                Capsule()
                                    .fill(Color(red: 0.5, green: 0.7, blue: 0.9))
                            )
                            .shadow(color: .blue.opacity(0.15), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.bottom, 20)

                // Paper Input Area
                ZStack {
                    if !isReleasing {
                        TextEditor(text: $text)
                            .font(.system(size: 20, weight: .regular, design: .serif))
                            .lineSpacing(8)
                            .scrollContentBackground(.hidden)
                            .padding(EdgeInsets(top: 40, leading: 90, bottom: 40, trailing: 40))
                            .background(
                                PaperView()
                                    .shadow(color: .black.opacity(0.1), radius: 25, x: 0, y: 15)
                            )
                            .transition(.asymmetric(
                                insertion: .opacity,
                                removal: .scale.combined(with: .opacity).combined(with: .offset(y: 800))
                            ))
                    }
                }
                .padding(.horizontal, 30)
                .frame(maxWidth: 800, maxHeight: 420) // Much more constrained height to prevent covering other UI
                .layoutPriority(1) 

                Spacer()

                // Release Button
                VStack(spacing: 20) {
                    Button(action: {
                        SoundManager.instance.playSound(.buttonClick)
                        releaseConfession()
                    }) {
                        Text("Release Thoughts")
                            .font(.title3)
                            .fontWeight(.light)
                            .foregroundColor(.white)
                            .frame(width: 240, height: 60)
                            .background(
                                ZStack {
                                    Capsule()
                                        .fill(text.isEmpty ? Color.gray.opacity(0.4) : Color(red: 0.4, green: 0.6, blue: 0.8))
                                    if !text.isEmpty {
                                        Capsule()
                                            .stroke(Color.white.opacity(0.4), lineWidth: 1)
                                    }
                                }
                            )
                            .shadow(color: text.isEmpty ? .clear : .blue.opacity(0.2), radius: 15, x: 0, y: 8)
                    }
                    .disabled(text.isEmpty || isReleasing)
                    
                    // Trash Bin Indicator
                    if isReleasing {
                        Image(systemName: "trash.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5).opacity(0.2))
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        Color.clear.frame(height: 80)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showResetTips) {
            EmotionSelectionView()
        }
        .safeAreaInset(edge: .top) {
            HStack {
                Button(action: { 
                    SoundManager.instance.playSound(.buttonClick)
                    dismiss() 
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 18)
                    .background(.ultraThinMaterial)
                    .cornerRadius(25)
                    .shadow(color: .black.opacity(0.08), radius: 8)
                }
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.top, 10)
        }
    }
    
    private func releaseConfession() {
        withAnimation(.easeInOut(duration: 1.4)) {
            isReleasing = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            text = ""
            isReleasing = false
            currentQuestion = "Let everything out of your mind"
        }
    }
}

struct PaperView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(red: 0.99, green: 0.99, blue: 0.98)
            
            // Guidelines and Sideline
            Canvas { context, size in
                // Red sideline
                var sideline = Path()
                sideline.move(to: CGPoint(x: 80, y: 0))
                sideline.addLine(to: CGPoint(x: 80, y: size.height))
                context.stroke(sideline, with: .color(Color.red.opacity(0.25)), lineWidth: 1.5)
                
                // Blue horizontal lines
                let lineSpacing: CGFloat = 36
                for i in 1...Int(size.height / lineSpacing) {
                    let y = CGFloat(i) * lineSpacing + 5
                    var path = Path()
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                    context.stroke(path, with: .color(Color.blue.opacity(0.08)), lineWidth: 1)
                }
                
                // Texture grain
                for _ in 0..<1000 {
                    let rect = CGRect(x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height), width: 1, height: 1)
                    context.fill(Path(ellipseIn: rect), with: .color(.black.opacity(0.02)))
                }
            }
        }
        .cornerRadius(10)
    }
}

#Preview {
    LetItOutView()
}
