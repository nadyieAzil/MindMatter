import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Nature Background Wallpaper
                Image("WelcomeWallpaper")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                // Soft overlay to ensure readability
                Color.white.opacity(0.15)
                    .background(.ultraThinMaterial.opacity(0.3))
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    Spacer()
                    
                    // App Title and Description
                    VStack(spacing: 12) {
                        Text("Mind Matters")
                            .font(.system(size: 72, weight: .thin, design: .serif))
                            .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                            .shadow(color: .white.opacity(0.4), radius: 8)
                        
                        Text("Your sanctuary for peace and clarity.")
                            .font(.system(size: 20, weight: .light, design: .rounded))
                            .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.6))
                            .italic()
                            .padding(.horizontal, 40)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()

                    // Responsive Button Layout
                    AdaptiveStack(spacing: 30) {
                        WelcomeButton(
                            title: "Relaxing-Game",
                            icon: "gamecontroller",
                            color: Color(red: 0.5, green: 0.7, blue: 0.9)
                        )
                        
                        NavigationLink(destination: LetItOutView()) {
                            WelcomeButtonContent(
                                title: "Let-it-out",
                                icon: "heart.text.square"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        WelcomeButton(
                            title: "Tips",
                            icon: "lightbulb",
                            color: Color(red: 0.55, green: 0.75, blue: 0.95)
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct WelcomeButtonContent: View {
    let title: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
            
            Text(title)
                .font(.system(size: 18, weight: .medium))
        }
        .frame(width: 180, height: 160)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1.2)
                )
        )
        .foregroundColor(Color(red: 0.05, green: 0.25, blue: 0.45))
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
    }
}

struct WelcomeButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {
            print("\(title) tapped")
        }) {
            WelcomeButtonContent(title: title, icon: icon)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Utility for changing layout orientation based on screen size
struct AdaptiveStack<Content: View>: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    let spacing: CGFloat
    let content: () -> Content

    init(spacing: CGFloat = 20, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        if sizeClass == .compact {
            VStack(spacing: spacing, content: content)
        } else {
            HStack(spacing: spacing, content: content)
        }
    }
}

#Preview {
    WelcomeView()
}
