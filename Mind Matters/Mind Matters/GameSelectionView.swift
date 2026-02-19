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
                // Top Spacer to push everything down
                Spacer()
                
                // Header
                VStack(spacing: 8) {
                    Text("Relaxing Game")
                        .font(.system(size: 38, weight: .thin, design: .serif))
                        .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                    
                    Text("Choose Your Game")
                        .font(.system(size: 16, weight: .light, design: .rounded))
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.6))
                }
                .padding(.horizontal)

                // Equal Gap between Header and Cards
                Spacer()

                // Horizontal Game Selection
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 35) {
                            NavigationLink(destination: WaterRippleGameView()) {
                            GameCard(
                                title: "Water Ripple",
                                description: "Symbolizes calm. No competition, no pressure. Just flow with the ripples.",
                                icon: "drop.circle.fill",
                                color: Color(red: 0.4, green: 0.6, blue: 0.9)
                            )
                        }
                        .buttonStyle(GameCardButtonStyle())
                            
                            NavigationLink(destination: InfiniteRollGameView()) {
                                GameCard(
                                    title: "Infinite Roll",
                                    description: "A seamless loop of silk and ancient paper. A rhythmic journey for the mind.",
                                    icon: "scroll.fill",
                                    color: Color(red: 0.7, green: 0.5, blue: 0.3)
                                )
                            }
                            .buttonStyle(GameCardButtonStyle())
                            
                            Button(action: { print("Sand Sweep selected") }) {
                                GameCard(
                                    title: "Sand Sweep",
                                    description: "Clearing mess is clearing the mind. A symbolic gesture of peace and renewal.",
                                    icon: "leaf.fill",
                                    color: Color(red: 0.6, green: 0.7, blue: 0.4)
                                )
                            }
                            .buttonStyle(GameCardButtonStyle())
                        }
                        .padding(.horizontal, 40)
                        .frame(minWidth: geometry.size.width, alignment: .center)
                    }
                }
                .frame(height: 380) // Match card height and constrain GeometryReader
                
                // Bottom Spacer to balance the top
                Spacer()
                Spacer() // Extra weight at the bottom to slightly uplift the center line
            }
            
        }
        .navigationBarHidden(true)
        .safeAreaInset(edge: .top) {
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                        Text("Back to Main Page")
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
}

struct GameCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 25)
            
            // Icon Circle
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 90, height: 90)
                    .overlay(
                        Circle()
                            .stroke(color.opacity(0.2), lineWidth: 1)
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundColor(color)
            }
            
            Spacer(minLength: 30) // Increased spacer to push title down
            
            VStack(spacing: 10) {
                Text(title)
                    .font(.system(size: 24, weight: .light, design: .serif))
                    .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.4))
                
                Text(description)
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.5))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .frame(height: 60)
            }
            
            Spacer(minLength: 15)
            
            // Subtle "Start" indicator
            HStack {
                Text("Enter Room")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(color)
                Image(systemName: "arrow.right")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(color)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 7)
            .background(color.opacity(0.08).cornerRadius(15))
            
            Spacer(minLength: 25)
        }
        .padding(.horizontal, 25)
        .frame(width: 260, height: 380) 
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
}

// Custom button style for the cards to handle the spring animation
struct GameCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    GameSelectionView()
}
