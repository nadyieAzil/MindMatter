import SwiftUI
import AVFoundation

struct Ripple: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    var age: Double = 0
}

struct WaterRippleGameView: View {
    @Environment(\.dismiss) var dismiss
    @State private var ripples: [Ripple] = []
    @State private var hapticGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    // Breathing state
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingText: String = "In"
    @State private var showBreathingGuide = true
    
    let maxAge: Double = 3.5
    let rippleSpeed: Double = 1.2
    
    var body: some View {
        ZStack {
            // Deep water background with subtle motion
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.1, green: 0.25, blue: 0.45),
                        Color(red: 0.05, green: 0.15, blue: 0.3)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Subtle overlay to add depth
                Color.cyan.opacity(0.05)
                    .blendMode(.screen)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .ignoresSafeArea()
            
            // Ripple Canvas
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    for ripple in ripples {
                        let progress = ripple.age / maxAge
                        let opacity = pow(1.0 - progress, 2) // Non-linear fade for natural look
                        let radius = CGFloat(progress * 400)
                        
                        var path = Path()
                        path.addEllipse(in: CGRect(
                            x: ripple.x - radius,
                            y: ripple.y - radius,
                            width: radius * 2,
                            height: radius * 2
                        ))
                        
                        // Main Ripple Line
                        context.stroke(
                            path,
                            with: .color(.white.opacity(opacity * 0.3)),
                            lineWidth: 3 * (1.0 - progress)
                        )
                        
                        // Secondary Wave Line
                        if progress > 0.1 {
                            let innerRadius = radius * 0.8
                            var innerPath = Path()
                            innerPath.addEllipse(in: CGRect(
                                x: ripple.x - innerRadius,
                                y: ripple.y - innerRadius,
                                width: innerRadius * 2,
                                height: innerRadius * 2
                            ))
                            context.stroke(
                                innerPath,
                                with: .color(.cyan.opacity(opacity * 0.1)),
                                lineWidth: 1 * (1.0 - progress)
                            )
                        }
                    }
                }
                .onChange(of: timeline.date) { oldDate, newDate in
                    updateRipples()
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        addRipple(at: value.location)
                    }
            )
            
            // Breathing Guide Overlay
            if showBreathingGuide {
                VStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                            .frame(width: 260, height: 260)
                        
                        Circle()
                            .fill(.white.opacity(0.08))
                            .frame(width: 220 * breathingScale, height: 220 * breathingScale)
                            .blur(radius: 15)
                        
                        VStack(spacing: 8) {
                            Text(breathingText)
                                .font(.system(size: 26, weight: .ultraLight, design: .serif))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(.bottom, 100)
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
                }
                .allowsHitTesting(false)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .safeAreaInset(edge: .top) {
            HStack(alignment: .center) {
                Button(action: { 
                    SoundManager.instance.playSound(.buttonClick)
                    dismiss() 
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                        Text("Exit")
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
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Water Ripple")
                        .font(.system(size: 18, weight: .light, design: .serif))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            showBreathingGuide.toggle()
                        }
                    }) {
                        Image(systemName: showBreathingGuide ? "wind" : "wind.circle")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 15) // Increased top padding for better safe area clearance
        }
        .onAppear {
            hapticGenerator.prepare()
            startBreathingCycle()
        }
    }
    
    private func addRipple(at point: CGPoint) {
        // Limit frequency of ripples for performance/feel
        if let last = ripples.last, last.age < 0.1 { return }
        
        SoundManager.instance.playSound(.waterPop, volume: 0.3)
        ripples.append(Ripple(x: point.x, y: point.y))
        hapticGenerator.impactOccurred(intensity: 0.4)
        
        // Cleanup old ripples
        if ripples.count > 30 {
            ripples.removeFirst()
        }
    }
    
    private func updateRipples() {
        for i in ripples.indices {
            ripples[i].age += 0.016 // Approx 60fps
        }
        ripples.removeAll { $0.age >= maxAge }
    }
    
    private func startBreathingCycle() {
        // Simple 4-4-4-4 cycle
        func runCycle() {
            // IN
            breathingText = "Inhale"
            withAnimation(.easeInOut(duration: 4.0)) {
                breathingScale = 1.3
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                // HOLD
                breathingText = "Hold"
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    // OUT
                    breathingText = "Exhale"
                    withAnimation(.easeInOut(duration: 4.0)) {
                        breathingScale = 0.8
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        // HOLD
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

#Preview {
    WaterRippleGameView()
}
