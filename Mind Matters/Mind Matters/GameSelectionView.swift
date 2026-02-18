import SwiftUI

struct GameSelectionView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background
            Image("WelcomeWallpaper") // Dynamic background could be added later
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .blur(radius: 10)
            
            Color.white.opacity(0.2)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                            .padding()
                            .background(Circle().fill(.ultraThinMaterial))
                    }
                    
                    Spacer()
                    
                    Text("Mini Games")
                        .font(.system(size: 34, weight: .thin, design: .serif))
                        .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                    
                    Spacer()
                    
                    // Invisible spacer for centering
                    Circle().fill(.clear).frame(width: 50)
                }
                .padding(.horizontal)
                .padding(.top, 20)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        GameCard(
                            title: "Water Ripple",
                            description: "Symbolizes calm. No competition, just presence.",
                            icon: "drop.circle.fill",
                            color: Color(red: 0.4, green: 0.6, blue: 0.9)
                        )
                        
                        GameCard(
                            title: "Infinite Roll",
                            description: "A seamless loop of silk and ancient paper.",
                            icon: "scroll.fill",
                            color: Color(red: 0.7, green: 0.5, blue: 0.3)
                        )
                        
                        GameCard(
                            title: "Sand Sweep",
                            description: "Clearing mess, clearing mind. Emotionally symbolic.",
                            icon: "leaf.fill",
                            color: Color(red: 0.6, green: 0.7, blue: 0.4)
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
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
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: icon)
                        .font(.system(size: 30))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.4))
                    
                    Text(description)
                        .font(.system(size: 15, weight: .light))
                        .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.5))
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.black.opacity(0.2))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.4), lineWidth: 1)
                    )
            )
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            .scaleEffect(isPressing ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressing)
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
