//
//  ContentView.swift
//  SolarDatePicker
//
//  Created by HEssam on 1/21/25.
//

import SwiftUI

struct ContentView: View {
    @State private var pulseArr : [PulseModel] = []
    
    @State private var previousAngle: CGFloat = 0
    @State private var angle: CGFloat = 0
    @State private var moonAngle: CGFloat = 0
    @State private var sum: Int = 0
    @State private var numberOfRotate: Int = 0
    
    var today = Date()
    @State private var newDate: Date = Date()
    
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    let circleRadius: CGFloat = 250.0
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                
                HStack {
                    Text(dateFormatter.string(from: newDate))
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .bold()
                    
                    Spacer()
                    
                    Image(.saturn)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                }
                .padding(.horizontal)
                .frame(width: 650, height: 80)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.secondaryBackground)
                )
                
                GeometryReader { geometry in
                    let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    ZStack {
                        Circle()
                            .stroke(.dash, style: StrokeStyle(lineWidth: 2, dash: [20, 10, 20, 10]))
                            .frame(width: circleRadius * 2, height: circleRadius * 2)
                            .position(center)
                            .rotationEffect(.radians(angle / 4))
                        
                        ZStack {
                            Circle()
                                .stroke(.dash, style: StrokeStyle(lineWidth: 2, dash: [8, 5, 8, 5]))
                                .frame(width: 100, height: 100)
                                .rotationEffect(.radians(-moonAngle / 4))
                            
                            Image(.moon)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .opacity(0.1)
                                .position(
                                    CGPoint(
                                        x: center.x + 50 * cos(moonAngle),
                                        y: center.y + 50 * sin(moonAngle)
                                    )
                                )
                            
                            Image(.moon)
                                .resizable()
                                .frame(width: 28, height: 28)
                                .opacity(0.05)
                                .position(
                                    CGPoint(
                                        x: center.x + 50 * cos(moonAngle),
                                        y: center.y + 50 * sin(moonAngle)
                                    )
                                )
                            
                            Image(.moon)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .position(
                                    CGPoint(
                                        x: center.x + 50 * cos(moonAngle),
                                        y: center.y + 50 * sin(moonAngle)
                                    )
                                )
                            
                            Image(.earth)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .opacity(0.1)
                            
                            Image(.earth)
                                .resizable()
                                .frame(width: 68, height: 68)
                                .opacity(0.05)
                            
                            Image(.earth)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .rotationEffect(.radians(-angle))
                        }
                        .position(
                            CGPoint(
                                x: center.x + circleRadius * cos(angle),
                                y: center.y + circleRadius * sin(angle)
                            )
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let vector = CGVector(dx: value.location.x - center.x, dy: value.location.y - center.y)
                                    let newAngle = atan2(vector.dy, vector.dx)
                                    
                                    let delta = newAngle - previousAngle
                                    
                                    if delta > 0, newAngle >= 0, previousAngle < 0, delta < .pi {
                                        numberOfRotate += 1
                                    } else if delta < 0, newAngle <= 0, previousAngle > 0, delta > -.pi {
                                        numberOfRotate -= 1
                                    }
                                    
                                    var newAngleInDegrees = newAngle * 180 / .pi
                                    
                                    if newAngleInDegrees < 0 {
                                        newAngleInDegrees += 360
                                    }
                                    
                                    let normalizedAngle = Int((newAngleInDegrees / 360) * 365)
                                    
                                    sum = numberOfRotate * 365 + normalizedAngle
                                    
                                    var dateComponents = DateComponents()
                                    dateComponents.day = sum
                                    if let newDate = calendar.date(byAdding: dateComponents, to: today) {
                                        self.newDate = newDate
                                    }
                                    
                                    previousAngle = newAngle
                                    angle = newAngle
                                    moonAngle = newAngle * 12
                                }
                        )
                        
                        // center
                        TimelineView(.animation(minimumInterval: 1.25, paused: false)) { timeline in
                            ZStack {
                                ForEach(pulseArr) { pulse in
                                    PulseAnimation(imageResource: .sun)
                                }
                            }
                            .onChange(of: timeline.date) { oldValue, newValue in
                                let pulseObj = PulseModel()
                                withAnimation {
                                    pulseArr.append(pulseObj)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                                    withAnimation {
                                        pulseArr.removeAll(where: { $0.id == pulseObj.id })
                                    }
                                }
                            }
                        }
                        
                        Image(.sun)
                            .resizable()
                            .frame(width: 120, height: 120)
                    }
                    .onAppear {
                        dateFormatter.dateFormat = "MM-dd-yyyy"
                    }
                }
                .frame(width: 650, height: 650)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.secondaryBackground)
                )
                
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
