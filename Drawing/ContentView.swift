//
//  ContentView.swift
//  Drawing
//
//  Created by Talita Groppo on 18/02/2021.
//

import SwiftUI

struct Arrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: (rect.maxX - rect.minX) * 0.33, y: rect.midY))
        path.addLine(to: CGPoint(x: (rect.maxX - rect.minX) * 0.33, y: rect.maxY))
        path.addLine(to: CGPoint(x: (rect.maxX - rect.minX) * 0.66, y: rect.maxY))
        path.addLine(to: CGPoint(x: (rect.maxX - rect.minX) * 0.66, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct ContentView: View {
    @State private var lineWidth: CGFloat = 10
        @State private var colorCycle = 0.0
        @State private var startPosition: UnitPoint = .top
        @State private var endPosition: UnitPoint = .bottom
    
    var body: some View {
        VStack {
            Arrow()
                .stroke(Color.pink, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .frame(width: 300, height: 300)
                .onTapGesture {
                    withAnimation {
                        self.lineWidth = CGFloat.random(in: 10...90)
                    }
                }
            Slider(value: $lineWidth, in: 10...90, step: 1)
                .padding()
            
            ColorCyclingRectangle(amount: self.colorCycle, startPosition: startPosition, endPosition: endPosition)
                            .frame(width: 100, height: 100)
                            .onTapGesture {
                                withAnimation {
                                    
                                    self.startPosition = self.startPosition == .top ? .leading : .top
                                    self.endPosition = self.endPosition == .bottom ? .trailing : .bottom
                                }
                            }
                        
                        Slider(value: $colorCycle)
                            .padding()
        }
    }
}
struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 100
    var startPosition: UnitPoint = .top
    var endPosition: UnitPoint = .bottom
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.5)
                    ]), startPoint: startPosition, endPoint: endPosition), lineWidth: 2)
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
