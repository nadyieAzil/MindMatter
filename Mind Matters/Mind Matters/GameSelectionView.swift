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
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                            .padding(12)
                            .background(Circle().fill(.ultraThinMaterial))
                            .shadow(color: .black.opacity(0.05), radius: 5)
                    }
                    
                    Spacer()
                    
                    Text("Choose Your Calm")
                        .font(.system(size: 32, weight: .thin, design: .serif))
                        .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                    
                    Spacer()
                    
                    // Balanced spacer
                    Circle().fill(.clear).frame(width: 46)
                }
                .padding(.horizontal, 25)
                .padding(.top, 20)
                .padding(.bottom, 40)

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
                    .padding(.vertical, 20)
                }
                
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
            VStack(spacing: 25) {
                // Large Icon Circle
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(color.opacity(0.3), lineWidth: 1)
                        )
                    
                    Image(systemName: icon)
                        .font(.system(size: 50))
                        .foregroundColor(color)
                        .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                
                VStack(spacing: 12) {
                    Text(title)
                        .font(.system(size: 28, weight: .light, design: .serif))
                        .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.4))
                    
                    Text(description)
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.5))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .frame(height: 80) // Fixed height for alignment
                }
                
                // Subtle "Start" indicator
                HStack {
                    Text("Enter Room")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(color)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(color)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(color.opacity(0.1).cornerRadius(20))
            }
            .padding(35)
            .frame(width: 300, height: 450)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1.5)
                    )
            )
            .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
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
