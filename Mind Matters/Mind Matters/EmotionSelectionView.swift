import SwiftUI

struct EmotionSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ZStack {
                // Nature Background Wallpaper
                Image("WelcomeWallpaper")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                    .clipped()
                    .ignoresSafeArea()
                
                // Aesthetic Layer: White + Blue tint overlay
                Color.white.opacity(0.75)
                    .ignoresSafeArea()
                Color(red: 0.1, green: 0.4, blue: 0.7).opacity(0.12)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // Header
                    VStack(spacing: 12) {
                        Text("Guided Reset")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                            .tracking(2)
                            .textCase(.uppercase)
                        
                        Text("How are you feeling right now?")
                            .font(.system(size: 32, weight: .thin, design: .serif))
                            .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 40)
                    
                    // Emotion Grid
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(ResetTipsData.emotions) { emotion in
                                NavigationLink(destination: GuidedResetTipsView(emotion: emotion)) {
                                    EmotionCard(emotion: emotion)
                                }
                                .simultaneousGesture(TapGesture().onEnded { SoundManager.instance.playSound(.buttonClick) })
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                    }
                    
                    Spacer()
                }
            .safeAreaInset(edge: .top) {
                HStack {
                    Button(action: { 
                        SoundManager.instance.playSound(.buttonClick)
                        dismiss() 
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                            Text("Cancel")
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
        .navigationBarBackButtonHidden(true)
    }
}

struct EmotionCard: View {
    let emotion: EmotionTips
    
    var body: some View {
        VStack(spacing: 15) {
            Text(emotion.emoji)
                .font(.system(size: 50))
            
            Text(emotion.name)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(emotion.color.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    EmotionSelectionView()
}
