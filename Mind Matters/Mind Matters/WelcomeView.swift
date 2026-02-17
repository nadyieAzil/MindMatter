import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [
                    Color(red: 0.85, green: 0.94, blue: 1.0), // Very light soft blue
                    Color(red: 0.70, green: 0.88, blue: 0.98)  // Slightly deeper soft blue
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Soft atmospheric "clouds" or glow
            VStack {
                HStack {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: -100, y: -100)
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 400, height: 400)
                        .blur(radius: 80)
                        .offset(x: 150, y: 150)
                }
            }
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()
                
                // App Name
                VStack(spacing: 8) {
                    Text("Mind Matters")
                        .font(.system(size: 64, weight: .thin, design: .serif))
                        .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
                    
                    Text("Your sanctuary for peace and clarity.")
                        .font(.system(size: 20, weight: .light, design: .rounded))
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.6))
                        .italic()
                }
                
                Spacer()
                
                // Category Buttons
                HStack(spacing: 30) {
                    WelcomeButton(
                        title: "Relaxing-Game",
                        icon: "gamecontroller",
                        color: Color(red: 0.5, green: 0.7, blue: 0.9)
                    )
                    
                    WelcomeButton(
                        title: "Let-it-out",
                        icon: "heart.text.square",
                        color: Color(red: 0.6, green: 0.8, blue: 0.85)
                    )
                    
                    WelcomeButton(
                        title: "Tips",
                        icon: "lightbulb",
                        color: Color(red: 0.55, green: 0.75, blue: 0.95)
                    )
                }
                .padding(.bottom, 60)
            }
            .padding()
        }
    }
}

struct WelcomeButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {
            // Action will be implemented later
            print("\(title) tapped")
        }) {
            VStack(spacing: 20) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
            }
            .frame(width: 200, height: 200)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
            )
            .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.5))
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    WelcomeView()
}
