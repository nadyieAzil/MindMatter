import SwiftUI

struct PaperRollGameView: View {
    @Environment(\.dismiss) var dismiss
    
    // Physics & Scroll State
    @State private var currentBottom: CGFloat = 0 
    @State private var velocity: CGFloat = 0
    @State private var isDragging = false
    @State private var lastDragTime = Date()
    @State private var lastDragLocation: CGFloat = 0
    
    // Constants
    private let totalPaperLength: CGFloat = 32000
    private let friction: CGFloat = 0.97
    private let stopThreshold: CGFloat = 0.5
    
    // Breathing state
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingText: String = "In"
    @State private var showBreathingGuide = true
    
    // ID for cinematic transitions
    @State private var paperID = UUID()
    
    var body: some View {
        // MASTER ROOT ZSTACK - For guaranteed layering
        ZStack {
            // 1. BACKGROUND LAYER (Desk + Scrolling Paper)
            GeometryReader { geometry in
                let viewportHeight = geometry.size.height
                let viewportWidth = geometry.size.width
                let startBottom = viewportHeight * 0.45 
                let activeBottom = (currentBottom == 0 ? startBottom : currentBottom)
                
                ZStack(alignment: .top) {
                    // Desk Background
                    Color(red: 0.90, green: 0.85, blue: 0.78)
                        .frame(maxWidth: viewportWidth, maxHeight: viewportHeight)
                        .clipped()
                        .ignoresSafeArea()
                    
                    // Paper Sheet
                    PaperSheetView(height: totalPaperLength, totalWidth: viewportWidth)
                        .id(paperID)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                        .offset(y: -totalPaperLength + activeBottom)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    if !isDragging {
                                        lastDragLocation = value.location.y
                                        isDragging = true
                                    }
                                    let delta = value.location.y - lastDragLocation
                                    lastDragLocation = value.location.y
                                    
                                    // Subtle paper sound while pulling
                                    if abs(delta) > 1 {
                                        SoundManager.instance.playSound(.paperUnroll, volume: 0.1)
                                    }
                                    
                                    let nextBottom = (currentBottom == 0 ? startBottom : currentBottom) + delta
                                    if nextBottom < startBottom {
                                        currentBottom = startBottom + (nextBottom - startBottom) * 0.3
                                    } else {
                                        currentBottom = nextBottom
                                    }
                                    
                                    let now = Date()
                                    let timeDelta = now.timeIntervalSince(lastDragTime)
                                    if timeDelta > 0 {
                                        velocity = delta / CGFloat(timeDelta)
                                    }
                                    lastDragTime = now
                                }
                                .onEnded { _ in
                                    isDragging = false
                                    startInertia(viewportHeight: viewportHeight)
                                }
                        )
                    
                    // Instructional Text (Moves with bottom of paper)
                    if activeBottom < viewportHeight + 100 {
                        Text("pull me down")
                            .id("prompt-\(paperID.uuidString)")
                            .font(.system(size: 24, weight: .light, design: .serif))
                            .foregroundColor(Color.black.opacity(0.6))
                            .offset(y: activeBottom - 70)
                            .allowsHitTesting(false)
                            .opacity(Double(max(0, 1.0 - (activeBottom - startBottom) / 300)))
                            .transition(.opacity)
                    }
                }
                .onAppear {
                    currentBottom = startBottom
                }
            }
            .zIndex(0)
            
            // 2. BREATHING GUIDE LAYER (Root Center/Bottom)
            if showBreathingGuide {
                VStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(Color(red: 0.4, green: 0.3, blue: 0.2).opacity(0.1), lineWidth: 1)
                            .frame(width: 240, height: 240)
                        
                        Circle()
                            .fill(Color(red: 0.4, green: 0.3, blue: 0.2).opacity(0.05))
                            .frame(width: 200 * breathingScale, height: 200 * breathingScale)
                            .blur(radius: 12)
                        
                        Text(breathingText)
                            .font(.system(size: 28, weight: .ultraLight, design: .serif))
                            .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.6))
                    }
                    .padding(.bottom, 160) // Positioned above progress bar but below center
                }
                .allowsHitTesting(false)
                .zIndex(5)
            }
            
            // 3. PROGRESS BAR LAYER (Root Bottom)
            GeometryReader { rootGeo in
                VStack {
                    Spacer()
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.black.opacity(0.06))
                            .frame(width: 300, height: 10)
                        
                        let progress = calculateProgress(rootHeight: rootGeo.size.height)
                        Capsule()
                            .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                            .frame(width: 300 * progress, height: 10)
                            .shadow(color: Color.blue.opacity(0.2), radius: 6, y: 2)
                    }
                    .padding(.bottom, rootGeo.safeAreaInsets.bottom + 35) // Lowered per request
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .allowsHitTesting(false)
            }
            .zIndex(6)
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .safeAreaInset(edge: .top) {
            HStack(alignment: .top) {
                // Left: Exit
                Button(action: { 
                    SoundManager.instance.playSound(.buttonClick)
                    dismiss() 
                }) {
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
                
                // Center: Refill
                Button(action: {
                    SoundManager.instance.playSound(.buttonClick)
                    withAnimation(.easeInOut(duration: 0.8)) {
                        velocity = 0
                        currentBottom = 0
                        paperID = UUID() // Slide out left, slide in right
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
                
                Spacer()
                
                // Right: Title & Toggle
                VStack(alignment: .trailing, spacing: 8) {
                    Text("Paper Roll")
                        .font(.system(size: 22, weight: .thin, design: .serif))
                        .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.4))
                    
                    Button(action: {
                        SoundManager.instance.playSound(.buttonClick)
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
            .padding(.horizontal, 25)
            .padding(.top, 10)
        }
        .onAppear {
            startBreathingCycle()
        }
    }
    
    private func calculateProgress(rootHeight: CGFloat) -> CGFloat {
        let startBottom = rootHeight * 0.45
        let currentPos = currentBottom == 0 ? startBottom : currentBottom
        return min(1.0, max(0.0, (currentPos - startBottom) / (totalPaperLength - startBottom)))
    }
    
    private func startInertia(viewportHeight: CGFloat) {
        func step() {
            if isDragging { return }
            currentBottom += velocity * 0.016 
            velocity *= friction
            let startBottom = viewportHeight * 0.45
            if currentBottom < startBottom {
                currentBottom = startBottom
                velocity = 0
            } else if currentBottom > totalPaperLength {
                currentBottom = totalPaperLength
                velocity = 0
            }
            if abs(velocity) > stopThreshold {
                // Subtle sound during inertia
                if Int.random(in: 0...10) == 0 {
                    SoundManager.instance.playSound(.paperUnroll, volume: 0.05)
                }
                
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
            withAnimation(.easeInOut(duration: 4.0)) { breathingScale = 1.3 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                breathingText = "Hold"
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    breathingText = "Exhale"
                    withAnimation(.easeInOut(duration: 4.0)) { breathingScale = 0.8 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        breathingText = "Rest"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { runCycle() }
                    }
                }
            }
        }
        runCycle()
    }
}

struct PaperSheetView: View {
    let height: CGFloat
    let totalWidth: CGFloat
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white
            Canvas { context, size in
                for _ in 0..<3500 {
                    let rect = CGRect(x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height), width: 1, height: 1)
                    context.fill(Path(ellipseIn: rect), with: .color(.black.opacity(0.02)))
                }
            }
            Rectangle()
                .fill(Color.red.opacity(0.35))
                .frame(width: 1.5)
                .padding(.leading, 65)
            VStack(spacing: 30) {
                ForEach(0..<Int(height / 30) + 1, id: \.self) { _ in
                    Rectangle().fill(Color.blue.opacity(0.1)).frame(height: 1)
                }
            }
            HStack {
                LinearGradient(gradient: Gradient(colors: [.black.opacity(0.05), .clear]), startPoint: .leading, endPoint: .trailing).frame(width: 12)
                Spacer()
                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.05)]), startPoint: .leading, endPoint: .trailing).frame(width: 12)
            }
        }
        .frame(width: totalWidth - 40, height: height)
        .cornerRadius(2, corners: [.bottomLeft, .bottomRight])
        .shadow(color: .black.opacity(0.1), radius: 12, y: 5)
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
