import SwiftUI

struct SandPoint: Identifiable {
    let id = UUID()
    let location: CGPoint
    let createdAt = Date()
}

struct SandSweepGameView: View {
    @Environment(\.dismiss) var dismiss
    
    // Sand state
    @State private var trails: [[SandPoint]] = []
    @State private var currentTrail: [SandPoint] = []
    @State private var hapticGenerator = UIImpactFeedbackGenerator(style: .light)
    @State private var isFadeMode = false
    
    // Breathing state
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingText: String = "In"
    @State private var showBreathingGuide = true
    
    private let sandColor = Color(red: 0.92, green: 0.88, blue: 0.82)
    private let rakeColor = Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.12)
    
    var body: some View {
        ZStack {
            // Sand Background
            sandColor
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                .clipped()
                .ignoresSafeArea()
            
            // Texture - Subtle Grain
            Canvas { context, size in
                for _ in 0..<500 {
                    let rect = CGRect(
                        x: CGFloat.random(in: 0...size.width),
                        y: CGFloat.random(in: 0...size.height),
                        width: 1.5,
                        height: 1.5
                    )
                    context.fill(Path(ellipseIn: rect), with: .color(.black.opacity(0.03)))
                }
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
            
            // Drawing Canvas with Fade Logic
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let now = timeline.date
                    
                    // Filter and Draw trails
                    let activeTrails = isFadeMode ? trails.map { trail in
                        trail.filter { now.timeIntervalSince($0.createdAt) < 5.0 }
                    }.filter { !$0.isEmpty } : trails
                    
                    let activeCurrent = isFadeMode ? currentTrail.filter { now.timeIntervalSince($0.createdAt) < 5.0 } : currentTrail
                    
                    for trail in (activeTrails + [activeCurrent]) {
                        if trail.count > 1 {
                            var path = Path()
                            path.move(to: trail[0].location)
                            for i in 1..<trail.count {
                                path.addLine(to: trail[i].location)
                            }
                            
                            // Calculate global opacity based on age if in fade mode
                            let trailAge = now.timeIntervalSince(trail.first?.createdAt ?? now)
                            let opacity = isFadeMode ? max(0, 1.0 - (trailAge / 5.0)) : 1.0
                            
                            // Main Rake Trail
                            context.stroke(
                                path,
                                with: .color(rakeColor.opacity(opacity)),
                                style: StrokeStyle(lineWidth: 25, lineCap: .round, lineJoin: .round)
                            )
                            
                            // Inner "Groove" Lines
                            context.stroke(
                                path,
                                with: .color(rakeColor.opacity(0.3 * opacity)),
                                style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [2, 10])
                            )
                        }
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if currentTrail.isEmpty {
                            hapticGenerator.prepare()
                        }
                        
                        let newPoint = SandPoint(location: value.location)
                        currentTrail.append(newPoint)
                        
                        // Gritty haptic feel & sound
                        if currentTrail.count % 10 == 0 {
                            hapticGenerator.impactOccurred(intensity: 0.3)
                            SoundManager.instance.playSound(.sandBrush, volume: 0.1)
                        }
                    }
                    .onEnded { _ in
                        SoundManager.instance.playSound(.sandBrush, volume: 0.2)
                        trails.append(currentTrail)
                        currentTrail = []
                        
                        // Cleanup to keep performance smooth (non-fade mode)
                        if !isFadeMode && trails.count > 25 {
                            trails.removeFirst()
                        }
                    }
            )
            
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
                        Button(action: { 
                            SoundManager.instance.playSound(.buttonClick)
                            dismiss() 
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                Text("Exit")
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.2).opacity(0.6))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background(.ultraThinMaterial.opacity(0.5))
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.05), radius: 8)
                        }
                        Spacer()
                    }
                    
                    // Center: Reset & Mode
                    HStack(spacing: 15) {
                        Button(action: {
                            SoundManager.instance.playSound(.buttonClick)
                            withAnimation(.spring()) {
                                trails = []
                                currentTrail = []
                            }
                            hapticGenerator.impactOccurred(intensity: 0.5)
                        }) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.7))
                                .padding(12)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.05), radius: 5)
                        }
                        
                        Button(action: {
                            SoundManager.instance.playSound(.buttonClick)
                            withAnimation(.spring()) {
                                isFadeMode.toggle()
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: isFadeMode ? "sparkles" : "infinity")
                                Text(isFadeMode ? "Fade" : "Static")
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
                            Text("Sand Sweep")
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

#Preview {
    SandSweepGameView()
}
