import SwiftUI

struct PaperRollGameView: View {
    @Environment(\.dismiss) var dismiss
    
    // Physics & Scroll State
    @State private var currentBottom: CGFloat = 0 // Position of the paper's bottom edge
    @State private var velocity: CGFloat = 0
    @State private var isDragging = false
    @State private var lastDragTime = Date()
    @State private var lastDragLocation: CGFloat = 0
    
    // Constants
    private let totalPaperLength: CGFloat = 16000
    private let friction: CGFloat = 0.97
    private let stopThreshold: CGFloat = 0.5
    
    // Breathing state
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingText: String = "In"
    @State private var showBreathingGuide = true
    
    var body: some View {
        GeometryReader { geometry in
            let viewportHeight = geometry.size.height
            let startBottom = viewportHeight * 0.45 // Initial unrolled tab height
            
            ZStack(alignment: .top) {
                // 1. Desk Background (Bottom Layer)
                Color(red: 0.90, green: 0.85, blue: 0.78)
                    .ignoresSafeArea()
                
                // 2. Paper Sheet content
                // We show the paper descending from the top.
                PaperSheetView(height: totalPaperLength)
                    .offset(y: -totalPaperLength + (currentBottom == 0 ? startBottom : currentBottom))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if !isDragging {
                                    lastDragLocation = value.location.y
                                    isDragging = true
                                }
                                
                                let delta = value.location.y - lastDragLocation
                                lastDragLocation = value.location.y
                                
                                let effectiveDelta = delta
                                
                                // Update bottom position
                                let nextBottom = (currentBottom == 0 ? startBottom : currentBottom) + effectiveDelta
                                
                                // Limit top boundary (cannot roll back into the machine)
                                if nextBottom < startBottom {
                                    currentBottom = startBottom + (nextBottom - startBottom) * 0.3
                                } else {
                                    currentBottom = nextBottom
                                }
                                
                                // Velocity calculation
                                let now = Date()
                                let timeDelta = now.timeIntervalSince(lastDragTime)
                                if timeDelta > 0 {
                                    velocity = effectiveDelta / CGFloat(timeDelta)
                                }
                                lastDragTime = now
                            }
                            .onEnded { _ in
                                isDragging = false
                                startInertia(viewportHeight: viewportHeight)
                            }
                    )
                
                // 3. Instructional Text (Moves with the bottom edge)
                let activeBottom = (currentBottom == 0 ? startBottom : currentBottom)
                if activeBottom < viewportHeight + 100 {
                    Text("pull me down")
                        .font(.system(size: 22, weight: .light, design: .serif))
                        .foregroundColor(Color.black.opacity(0.6))
                        .offset(y: activeBottom - 60)
                        .allowsHitTesting(false)
                        .opacity(Double(max(0, 1.0 - (activeBottom - startBottom) / 300)))
                }
                
                // --- TOP LAYERS (Always visible) ---
                
                // 4. Breathing Guide (Centered)
                if showBreathingGuide {
                    ZStack {
                        Circle()
                            .stroke(Color(red: 0.4, green: 0.3, blue: 0.2).opacity(0.15), lineWidth: 1)
                            .frame(width: 240, height: 240)
                        
                        Circle()
                            .fill(Color(red: 0.4, green: 0.3, blue: 0.2).opacity(0.12))
                            .frame(width: 200 * breathingScale, height: 200 * breathingScale)
                            .blur(radius: 12)
                        
                        Text(breathingText)
                            .font(.system(size: 26, weight: .light, design: .serif))
                            .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.6))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .allowsHitTesting(false)
                }
                
                // 5. Blue Progress Bar (Bottom Center)
                VStack {
                    Spacer()
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                            .frame(width: 280, height: 10)
                        
                        let progress = min(1.0, max(0.0, (activeBottom - startBottom) / (totalPaperLength - startBottom)))
                        Capsule()
                            .fill(Color(red: 0.0, green: 0.48, blue: 1.0)) // Vibrant Blue
                            .frame(width: 280 * progress, height: 10)
                            .shadow(color: Color.blue.opacity(0.2), radius: 6, x: 0, y: 2)
                    }
                    .padding(.bottom, 60)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .allowsHitTesting(false)
                
                // 6. Header
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
                                .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.6))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 15)
                                .background(.ultraThinMaterial.opacity(0.5))
                                .cornerRadius(20)
                            }
                            Spacer()
                        }
                        
                        // Center: Refill
                        HStack {
                            Button(action: {
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                                    currentBottom = startBottom
                                    velocity = 0
                                }
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "arrow.counterclockwise")
                                    Text("Refill Paper")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.6))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 15)
                                .background(.ultraThinMaterial.opacity(0.5))
                                .cornerRadius(20)
                            }
                        }
                        
                        // Right: Title & Wind
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing, spacing: 8) {
                                Text("Paper Roll")
                                    .font(.system(size: 22, weight: .thin, design: .serif))
                                    .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.4))
                                
                                Button(action: {
                                    withAnimation(.spring()) {
                                        showBreathingGuide.toggle()
                                    }
                                }) {
                                    Image(systemName: showBreathingGuide ? "wind" : "wind.circle")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.6))
                                        .padding(10)
                                        .background(.ultraThinMaterial.opacity(0.5))
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                currentBottom = startBottom
                startBreathingCycle()
            }
        }
    }
    
    private func startInertia(viewportHeight: CGFloat) {
        func step() {
            if isDragging { return }
            
            currentBottom += velocity * 0.016 
            velocity *= friction
            
            let startBottom = viewportHeight * 0.45
            
            // Boundary checks
            if currentBottom < startBottom {
                currentBottom = startBottom
                velocity = 0
            } else if currentBottom > totalPaperLength {
                currentBottom = totalPaperLength
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
                for _ in 0..<3500 {
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
                .fill(Color.red.opacity(0.35))
                .frame(width: 1.5)
                .padding(.leading, 65)
            
            // Horizontal Blue Lines
            VStack(spacing: 30) {
                ForEach(0..<Int(height / 30), id: \.self) { _ in
                    Rectangle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(height: 1)
                }
            }
            
            // Shadows at the edges for depth
            HStack {
                LinearGradient(gradient: Gradient(colors: [.black.opacity(0.05), .clear]), startPoint: .leading, endPoint: .trailing)
                    .frame(width: 12)
                Spacer()
                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.05)]), startPoint: .leading, endPoint: .trailing)
                    .frame(width: 12)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: height)
        .cornerRadius(2, corners: [.bottomLeft, .bottomRight])
        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 5)
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
