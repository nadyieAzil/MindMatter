import SwiftUI

struct InfiniteRollGameView: View {
    @Environment(\.dismiss) var dismiss
    
    // Scroll state
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @State private var hapticGenerator = UISelectionFeedbackGenerator()
    
    // Breathing state (consistent with Water Ripple)
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingText: String = "In"
    @State private var showBreathingGuide = true
    
    private let textureHeight: CGFloat = 1000
    
    var body: some View {
        ZStack {
            // Background - Warm parchment color
            Color(red: 0.94, green: 0.91, blue: 0.85)
                .ignoresSafeArea()
            
            // Texture Layers for Infinite Scrolling
            ZStack(alignment: .top) {
                PaperTextureView()
                    .offset(y: (offset.truncatingRemainder(dividingBy: textureHeight)) - textureHeight)
                
                PaperTextureView()
                    .offset(y: offset.truncatingRemainder(dividingBy: textureHeight))
                
                PaperTextureView()
                    .offset(y: (offset.truncatingRemainder(dividingBy: textureHeight)) + textureHeight)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let delta = value.translation.height - lastOffset
                        offset += delta
                        lastOffset = value.translation.height
                        
                        // Haptic feedback every few pixels of scroll
                        if abs(offset.truncatingRemainder(dividingBy: 20)) < abs(delta) {
                            hapticGenerator.selectionChanged()
                        }
                    }
                    .onEnded { _ in
                        lastOffset = 0
                        hapticGenerator.prepare()
                    }
            )
            
            // Side "Roller" Shadows for depth
            HStack {
                LinearGradient(gradient: Gradient(colors: [.black.opacity(0.1), .clear]), startPoint: .leading, endPoint: .trailing)
                    .frame(width: 40)
                Spacer()
                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.1)]), startPoint: .leading, endPoint: .trailing)
                    .frame(width: 40)
            }
            .ignoresSafeArea()
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
                HStack(alignment: .top) {
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
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 15) {
                        Text("Infinite Roll")
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
            hapticGenerator.prepare()
            startBreathingCycle()
        }
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

struct PaperTextureView: View {
    var body: some View {
        ZStack {
            // Main texture color (Warm, aged parchment)
            Color(red: 0.94, green: 0.92, blue: 0.86)
            
            // Subtle paper grain/noise (Using a gradient-based approach for performance)
            Canvas { context, size in
                // Draw many tiny organic fibers
                for i in 0..<120 {
                    let startX = CGFloat.random(in: 0...size.width)
                    let startY = CGFloat.random(in: 0...size.height)
                    let length = CGFloat.random(in: 10...60)
                    let angle = Angle.degrees(Double.random(in: -10...10))
                    
                    var path = Path()
                    path.move(to: CGPoint(x: startX, y: startY))
                    path.addLine(to: CGPoint(
                        x: startX + length * cos(angle.radians),
                        y: startY + length * sin(angle.radians)
                    ))
                    
                    context.stroke(
                        path,
                        with: .color(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.04)),
                        lineWidth: 0.5
                    )
                }
            }
            
            // Traditional Grid (Horizontal Lines like a manuscript)
            VStack(spacing: 60) {
                ForEach(0..<18) { _ in
                    Rectangle()
                        .fill(Color(red: 0.4, green: 0.3, blue: 0.2).opacity(0.06))
                        .frame(height: 1.2)
                }
            }
            
            // Side "Roller" Depth Highlights
            HStack {
                // Left Shadow
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.black.opacity(0.08), .black.opacity(0.02), .clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: 60)
                
                Spacer()
                
                // Right Shadow
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.02), .black.opacity(0.08)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: 60)
            }
        }
        .frame(height: 1000)
    }
}

#Preview {
    InfiniteRollGameView()
}
