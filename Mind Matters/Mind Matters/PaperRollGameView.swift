import SwiftUI

struct PaperRollGameView: View {
    @Environment(\.dismiss) var dismiss
    
    // Physics & Scroll State
    @State private var offset: CGFloat = 0 // Offset from bottom
    @State private var velocity: CGFloat = 0
    @State private var isDragging = false
    @State private var lastDragTime = Date()
    @State private var lastDragLocation: CGFloat = 0
    
    // Paper Constants
    private let totalPaperLength: CGFloat = 8000
    private let friction: CGFloat = 0.96
    private let stopThreshold: CGFloat = 0.5
    
    // Breathing state
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingText: String = "In"
    @State private var showBreathingGuide = true
    
    var body: some View {
        GeometryReader { geometry in
            let viewportHeight = geometry.size.height
            let startOffset = viewportHeight * 0.5 // Start with paper half-way up from bottom
            let maxOffset = totalPaperLength - viewportHeight * 0.1 // Prevent rolling too far
            
            ZStack(alignment: .bottom) {
                // Background - Desk Color
                Color(red: 0.90, green: 0.85, blue: 0.78)
                    .ignoresSafeArea()
                
                // The Paper Sheet
                PaperSheetView(height: totalPaperLength)
                    .offset(y: -offset + startOffset)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                isDragging = true
                                let delta = value.location.y - lastDragLocation
                                
                                // Invert delta because we want to pull UP
                                let pullUpDelta = -delta
                                
                                // Apply displacement
                                offset += pullUpDelta
                                
                                // Bounds with elastic resistance
                                if offset < 0 {
                                    offset -= pullUpDelta * 0.7 
                                } else if offset > maxOffset {
                                    offset -= pullUpDelta * 0.7
                                }
                                
                                // Speed calculation
                                let now = Date()
                                let timeDelta = now.timeIntervalSince(lastDragTime)
                                if timeDelta > 0 {
                                    velocity = pullUpDelta / CGFloat(timeDelta)
                                }
                                
                                lastDragLocation = value.location.y
                                lastDragTime = now
                            }
                            .onEnded { _ in
                                isDragging = false
                                startInertia(maxOffset: maxOffset)
                            }
                    )
                
                // Instructional Overlay
                if offset < 100 {
                    VStack {
                        Image(systemName: "chevron.compact.up")
                            .font(.system(size: 30, weight: .thin))
                            .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.3))
                        Text("Pull me")
                            .font(.system(size: 20, weight: .light, design: .serif))
                            .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.4))
                            .padding(.top, 5)
                    }
                    .offset(y: -viewportHeight * 0.5 - 60)
                    .allowsHitTesting(false)
                    .opacity(Double(max(0, 1.0 - (offset / 100))))
                }
                
                // Breathing Guide (Must be above paper)
                if showBreathingGuide {
                    ZStack {
                        Circle()
                            .stroke(Color(red: 0.4, green: 0.3, blue: 0.2).opacity(0.1), lineWidth: 1)
                            .frame(width: 240, height: 240)
                        
                        Circle()
                            .fill(Color(red: 0.4, green: 0.3, blue: 0.2).opacity(0.05))
                            .frame(width: 200 * breathingScale, height: 200 * breathingScale)
                            .blur(radius: 10)
                        
                        Text(breathingText)
                            .font(.system(size: 24, weight: .ultraLight, design: .serif))
                            .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.5))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .allowsHitTesting(false)
                }
                
                // Blue Progress Bar
                VStack {
                    Spacer()
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                            .frame(width: 250, height: 8)
                        
                        let progress = min(1.0, max(0.0, offset / maxOffset))
                        Capsule()
                            .fill(Color(red: 0.0, green: 0.48, blue: 1.0)) // Vibrant Blue
                            .frame(width: 250 * progress, height: 8)
                            .shadow(color: Color.blue.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .padding(.bottom, 40)
                }
                .allowsHitTesting(false)
                
                // Header & Controls
                VStack {
                    ZStack(alignment: .top) {
                        // Left: Exit
                        HStack {
                            Button(action: { dismiss() }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "chevron.left")
                                    Text("Exit")
                                }
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.8))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 18)
                                .background(.ultraThinMaterial)
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.05), radius: 8)
                            }
                            Spacer()
                        }
                        
                        // Center: Refill
                        HStack {
                            Button(action: {
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                                    offset = 0
                                    velocity = 0
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.counterclockwise")
                                    Text("Refill Paper")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.7))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 18)
                                .background(.ultraThinMaterial)
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.05), radius: 5)
                            }
                        }
                        
                        // Right: Title & Wind
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing, spacing: 10) {
                                Text("Paper Roll")
                                    .font(.system(size: 24, weight: .thin, design: .serif))
                                    .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.5))
                                
                                Button(action: {
                                    withAnimation(.spring()) {
                                        showBreathingGuide.toggle()
                                    }
                                }) {
                                    Image(systemName: showBreathingGuide ? "wind" : "wind.circle")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.7))
                                        .padding(12)
                                        .background(.ultraThinMaterial)
                                        .clipShape(Circle())
                                        .shadow(color: .black.opacity(0.05), radius: 5)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, geometry.size.width * 0.05)
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                startBreathingCycle()
            }
        }
    }
    
    private func startInertia(maxOffset: CGFloat) {
        func step() {
            if isDragging { return }
            
            offset += velocity * 0.016 
            velocity *= friction
            
            // Boundary checks with snap-back
            if offset < 0 {
                offset *= 0.8
                velocity = 0
            } else if offset > maxOffset {
                offset = maxOffset
                velocity = 0
            }
            
            if abs(velocity) > stopThreshold {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.016) {
                    step()
                }
            }
        }
        step()
    }
    
    private func startBreathingCycle() {
        func runCycle() {
            breathingText = "Inhale"
            withAnimation(.easeInOut(duration: 4.0)) {
                breathingScale = 1.3
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                breathingText = "Hold"
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    breathingText = "Exhale"
                    withAnimation(.easeInOut(duration: 4.0)) {
                        breathingScale = 0.8
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        breathingText = "Rest"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            runCycle()
                        }
                    }
                }
            }
        }
        runCycle()
    }
}

struct PaperSheetView: View {
    let height: CGFloat
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Paper Surface
            Color.white
            
            // Texture - Grain
            Canvas { context, size in
                for _ in 0..<3000 {
                    let rect = CGRect(
                        x: CGFloat.random(in: 0...size.width),
                        y: CGFloat.random(in: 0...size.height),
                        width: 1,
                        height: 1
                    )
                    context.fill(Path(ellipseIn: rect), with: .color(.black.opacity(0.02)))
                }
            }
            
            // Vertical Red Margin Line
            Rectangle()
                .fill(Color.red.opacity(0.4))
                .frame(width: 2)
                .padding(.leading, 70)
            
            // Horizontal Blue Lines
            VStack(spacing: 32) {
                ForEach(0..<Int(height / 32), id: \.self) { _ in
                    Rectangle()
                        .fill(Color.blue.opacity(0.12))
                        .frame(height: 1)
                }
            }
            
            // Shadows at the edges for depth
            HStack {
                LinearGradient(gradient: Gradient(colors: [.black.opacity(0.06), .clear]), startPoint: .leading, endPoint: .trailing)
                    .frame(width: 15)
                Spacer()
                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.06)]), startPoint: .leading, endPoint: .trailing)
                    .frame(width: 15)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 60, height: height)
        .cornerRadius(4, corners: [.topLeft, .topRight])
        .shadow(color: .black.opacity(0.12), radius: 15, x: 0, y: -5)
    }
}

// Helper for specific corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    PaperRollGameView()
}

