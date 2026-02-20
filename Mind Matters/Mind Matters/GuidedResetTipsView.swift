import SwiftUI

struct GuidedResetTipsView: View {
    @Environment(\.dismiss) private var dismiss
    let emotion: EmotionTips
    
    var body: some View {
        ZStack {
            // Soft Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [emotion.color.opacity(0.1), .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Space
                Color.clear.frame(height: 100)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Title & Validation
                        VStack(spacing: 16) {
                            Text("\(emotion.emoji) \(emotion.name)")
                                .font(.system(size: 40, weight: .thin, design: .serif))
                                .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 1)
                                .padding(.horizontal, 60)
                            
                            Text(emotion.validation)
                                .font(.system(size: 20, weight: .light, design: .rounded))
                                .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.6))
                                .italic()
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .padding(.top, 20)
                        
                        // Techniques List
                        VStack(spacing: 20) {
                            ForEach(emotion.techniques) { technique in
                                TechniqueCard(technique: technique)
                            }
                        }
                        .padding(.horizontal, 25)
                        
                        // Ripple Mode Button
                        NavigationLink(destination: WaterRippleGameView()) {
                            HStack {
                                Image(systemName: "water.waves")
                                Text("Open Ripple Mode")
                            }
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(
                                Capsule()
                                    .fill(Color(red: 0.4, green: 0.6, blue: 0.8))
                                    .shadow(color: .blue.opacity(0.2), radius: 10, x: 0, y: 5)
                            )
                        }
                        .simultaneousGesture(TapGesture().onEnded { SoundManager.instance.playSound(.buttonClick) })
                        .padding(.horizontal, 40)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
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
                    .shadow(color: .black.opacity(0.05), radius: 5)
                }
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.top, 10)
        }
    }
}

struct TechniqueCard: View {
    let technique: Technique
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(technique.title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.gray.opacity(0.5))
            }
            
            Text(technique.whyItHelps)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                .lineLimit(isExpanded ? nil : 1)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(technique.steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(index + 1)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .background(Circle().fill(Color(red: 0.5, green: 0.7, blue: 0.9)))
                            
                            Text(step)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.4))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    Button(action: {
                        SoundManager.instance.playSound(.buttonClick)
                        // This could eventually trigger a timer or guided session
                    }) {
                        Text("Start Now")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                Capsule()
                                    .stroke(Color(red: 0.4, green: 0.6, blue: 0.8), lineWidth: 1.5)
                            )
                    }
                    .padding(.top, 10)
                }
                .padding(.top, 10)
                .transition(.opacity)
            }
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
        )
        .onTapGesture {
            withAnimation(.spring()) {
                isExpanded.toggle()
            }
        }
    }
}

#Preview {
    GuidedResetTipsView(emotion: ResetTipsData.emotions[0])
}
