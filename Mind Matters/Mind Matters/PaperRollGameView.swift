import SwiftUI

struct PaperRollGameView: View {
    @Environment(\.dismiss) var dismiss
    
    // Physics & Scroll State
    @State private var offset: CGFloat = 0
    @State private var velocity: CGFloat = 0
    @State private var isDragging = false
    @State private var lastDragTime = Date()
    @State private var lastDragOffset: CGFloat = 0
    
    // Paper Constants
    private let initialPaperHeight: CGFloat = 400
    private let totalPaperLength: CGFloat = 5000
    private let windowHeight: CGFloat = 1000 // Approximate, will be adjusted by GeometryReader
    
    // Breathing state
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingText: String = "In"
    @State private var showBreathingGuide = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background - Warm wood or desk color
                Color(red: 0.90, green: 0.85, blue: 0.78)
                    .ignoresSafeArea()
                
                // The Paper Roll
                VStack(spacing: 0) {
                    PaperSheetView(height: totalPaperLength, isTop: true)
                        .offset(y: offset)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    isDragging = true
                                    let delta = value.translation.height - lastDragOffset
                                    
                                    // Apply friction at boundaries
                                    let newOffset = offset + delta
                                    if newOffset > 0 {
                                        offset += delta * 0.3 // Elastic feel at top
                                    } else if newOffset < -(totalPaperLength - geometry.size.height + 100) {
                                        offset += delta * 0.3 // Elastic feel at bottom
                                    } else {
                                        offset = newOffset
                                    }
                                    
                                    // Calculate velocity
                                    let now = Date()
                                    let timeDelta = now.timeIntervalSince(lastDragTime)
                                    if timeDelta > 0 {
                                        velocity = delta / CGFloat(timeDelta)
                                    }
                                    
                                    lastDragOffset = value.translation.height
                                    lastDragTime = now
                                }
                                .onEnded { _ in
                                    isDragging = false
                                    lastDragOffset = 0
                                    startInertia()
                                }
                        )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
                // Instructions Overlay (Visible only at the start)
                if offset > -50 {
                    VStack {
                        Spacer()
                            .frame(height: 450)
                        Text("Pull me")
                            .font(.system(size: 20, weight: .light, design: .serif))
                            .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.4))
                            .padding(.top, 20)
                        Image(systemName: "chevron.compact.down")
                            .font(.system(size: 30, weight: .thin))
                            .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.3))
                    }
                    .allowsHitTesting(false)
                    .opacity(Double(max(0, 1.0 + (offset / 100))))
                }
                
                // Progress Bar (Life of the Roll)
                VStack {
                    Spacer()
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.black.opacity(0.05))
                            .frame(width: 200, height: 4)
                        
                        let progress = min(1.0, max(0.0, abs(offset) / (totalPaperLength - geometry.size.height)))
                        Capsule()
                            .fill(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.3))
                            .frame(width: 200 * progress, height: 4)
                    }
                    .padding(.bottom, 30)
                }
                .allowsHitTesting(false)
                
                // Breathing Guide Overlay
                if showBreathingGuide {
                    VStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .stroke(Color(red: 0.4, green: 0.3, blue: 0.2).opacity(0.1), lineWidth: 1)
                                .frame(width: 260, height: 260)
                            
                            Circle()
                                .fill(Color(red: 0.4, green: 0.3, blue: 0.2).opacity(0.05))
                                .frame(width: 220 * breathingScale, height: 220 * breathingScale)
                                .blur(radius: 15)
                            
                            VStack(spacing: 8) {
                                Text(breathingText)
                                    .font(.system(size: 26, weight: .ultraLight, design: .serif))
                                    .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.6))
                            }
                        }
                        .padding(.bottom, 100)
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    }
                    .allowsHitTesting(false)
                }
                
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
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    offset = 0
                                    velocity = 0
                                }
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "arrow.clockwise")
                                    Text("Refill Paper")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.7))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
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
                    .padding(.horizontal, 25)
                    .padding(.top, 130)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                startBreathingCycle()
            }
        }
    }
    
    private func startInertia() {
        let friction: CGFloat = 0.95
        let stopThreshold: CGFloat = 0.5
        
        func step() {
            if isDragging { return }
            
            offset += velocity * 0.016 // 60fps
            velocity *= friction
            
            // Boundary checks with bounce back
            if offset > 0 {
                offset *= 0.8 // Simple bounce
                velocity = 0
            } else if offset < -(totalPaperLength - windowHeight) {
                offset = -(totalPaperLength - windowHeight)
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
    let isTop: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Paper Surface
            Color.white
            
            // Texture - Subtle Paper Grains
            Canvas { context, size in
                for _ in 0..<2000 {
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
                .fill(Color.red.opacity(0.3))
                .frame(width: 1.5)
                .padding(.leading, 80)
            
            // Horizontal Blue Lines
            VStack(spacing: 30) {
                ForEach(0..<Int(height / 30), id: \.self) { _ in
                    Rectangle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(height: 1)
                }
            }
            .padding(.top, 0)
            
            // Torn edge at the top (if it's the start)
            if isTop {
                Rectangle()
                    .fill(Color.black.opacity(0.05))
                    .frame(height: 1)
            }
            
            // Shadow at the edges
            HStack {
                LinearGradient(gradient: Gradient(colors: [.black.opacity(0.05), .clear]), startPoint: .leading, endPoint: .trailing)
                    .frame(width: 15)
                Spacer()
                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.05)]), startPoint: .leading, endPoint: .trailing)
                    .frame(width: 15)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 100, height: height)
        .cornerRadius(2, corners: [.bottomLeft, .bottomRight])
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
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
