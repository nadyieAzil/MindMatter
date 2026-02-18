import SwiftUI

struct GameSelectionView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background
            Image("WelcomeWallpaper")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .blur(radius: 12)
            
            Color.white.opacity(0.15)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                            .padding(10)
                            .background(Circle().fill(.ultraThinMaterial))
                            .shadow(color: .black.opacity(0.05), radius: 5)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("Relaxing Game")
                            .font(.system(size: 36, weight: .thin, design: .serif))
                            .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                        
                        Text("Choose Your Game")
                            .font(.system(size: 16, weight: .light, design: .rounded))
                            .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.6))
                    }
                    
                    Spacer()
                    
                    // Balanced spacer
                    Circle().fill(.clear).frame(width: 40)
                }
                .padding(.horizontal, 25)
                .padding(.top, 20)
                .padding(.bottom, 20)

                Spacer()

                // Horizontal Game Selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        GameCard(
                            title: "Water Ripple",
                            description: "Symbolizes calm. No competition, no pressure. Just flow with the gentle ripples.",
                            icon: "drop.circle.fill",
                            color: Color(red: 0.4, green: 0.6, blue: 0.9)
                        )
                        
                        GameCard(
                            title: "Infinite Roll",
                            description: "A seamless loop of silk and ancient paper. A rhythmic journey for the mind.",
                            icon: "scroll.fill",
                            color: Color(red: 0.7, green: 0.5, blue: 0.3)
                        )
                        
                        GameCard(
                            title: "Sand Sweep",
                            description: "Clearing mess is clearing the mind. A symbolic gesture of peace and renewal.",
                            icon: "leaf.fill",
                            color: Color(red: 0.6, green: 0.7, blue: 0.4)
                        )
                    }
                    .padding(.horizontal, 40)
                    .frame(minWidth: UIScreen.main.bounds.width) // Helps center content if small
                }
                .frame(maxHeight: 420)
                
                Spacer()
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct GameCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    @State private var isPressing = false
    
    var body: some View {
        Button(action: {
            print("\(title) selected")
        }) {
            VStack(spacing: 0) {
                Spacer(minLength: 25)
                
                // Icon Circle
                ZStack {
                    Circle()
                        .fill(color.opacity(0.12))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Circle()
                                .stroke(color.opacity(0.2), lineWidth: 1)
                        )
                    
                    Image(systemName: icon)
                        .font(.system(size: 44))
                        .foregroundColor(color)
                }
                
                Spacer(minLength: 25) // Pushing the title down
                
                VStack(spacing: 10) {
                    Text(title)
                        .font(.system(size: 26, weight: .light, design: .serif))
                        .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.4))
                    
                    Text(description)
                        .font(.system(size: 15, weight: .light))
                        .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.5))
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .frame(height: 70)
                }
                
                Spacer(minLength: 15)
                
                // Subtle "Start" indicator
                HStack {
                    Text("Enter Room")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(color)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(color)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(color.opacity(0.08).cornerRadius(18))
                
                Spacer(minLength: 25)
            }
            .padding(.horizontal, 30)
            .frame(width: 280, height: 380) // Height reduced to 380, width reduced to 280 for better centering
            .background(
                RoundedRectangle(cornerRadius: 35)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 35)
                            .stroke(Color.white.opacity(0.4), lineWidth: 1.2)
                    )
            )
            .shadow(color: Color.black.opacity(0.06), radius: 15, x: 0, y: 8)
            .scaleEffect(isPressing ? 0.97 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isPressing)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressing = true }
                .onEnded { _ in isPressing = false }
        )
    }
}

#Preview {
    GameSelectionView()
}
