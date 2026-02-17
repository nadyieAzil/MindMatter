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

                VStack(spacing: 50) {
                    Spacer()
                    
                    // App Title and Description
                    VStack(spacing: 15) {
                        Text("Mind Matters")
                            .font(.system(size: 80, weight: .thin, design: .serif))
                            .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                            .shadow(color: .white.opacity(0.5), radius: 10)
                        
                        Text("Your sanctuary for peace and clarity.")
                            .font(.system(size: 24, weight: .light, design: .rounded))
                            .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.6))
                            .italic()
                            .padding(.horizontal, 40)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Category Buttons - Now centered under description
                    HStack(spacing: 40) {
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
                    .padding(.top, 20)
                    
                    Spacer()
                    Spacer() // Pushes everything slightly up for better centering in large screens
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
        VStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 45))
            
            Text(title)
                .font(.title3)
                .fontWeight(.medium)
        }
        .frame(width: 220, height: 200)
        .background(
            RoundedRectangle(cornerRadius: 35)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(Color.white.opacity(0.6), lineWidth: 1.5)
                )
        )
        .foregroundColor(Color(red: 0.05, green: 0.25, blue: 0.45))
        .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 8)
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

#Preview {
    WelcomeView()
}
