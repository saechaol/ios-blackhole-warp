//
//  CircleView.swift
//  ImageWarp
//
//  Created by 세차오 루카스 on 6/22/25.
//

import SwiftUI

struct CircleView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var position = CGPoint(x: 180, y: 180)
    @State private var imageSize = CGSize(width: 360, height: 360)
    @State private var angle: Double = 100
    @State private var blurAmount: Double = 10
    
    var circlePrimaryColor: some ShapeStyle {
        if colorScheme == .dark {
            return LinearGradient.subjectPrimaryDark
        } else {
            return LinearGradient.subjectPrimaryLight
        }
    }
    
    var textColor: some ShapeStyle {
        if colorScheme == .dark {
            return Color.white
        } else {
            return Color.white
        }
    }
    var body: some View {
        ZStack {
            LinearGradient.appPrimary
                .ignoresSafeArea()
            Circle()
                .fill(circlePrimaryColor)
                .frame(width: imageSize.width, height: imageSize.height)
                .scaledToFill()
                .blur(radius: blurAmount)
                .layerEffect(
                    ShaderLibrary.light(
                        .float2(imageSize),
                        .float2(position),
                        .float(angle)
                    ), maxSampleOffset: CGSize(width: 320, height: 360)
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            position = value.location
                        }
                )
            VStack {
                Text("Angle: \(String(format: "%.2f", angle)), Blur: \(String(format: "%.2f", blurAmount))")
                    .font(.system(size: 18, design: .rounded))
                    .foregroundStyle(textColor)
                    .shadow(
                        color: .black.opacity(0.4),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
                    .padding()
                HStack {
                    Text("Angle")
                        .font(.system(
                            size: 14,
                            design: .monospaced
                        ))
                        .foregroundStyle(textColor)
                        .shadow(
                            color: .black.opacity(0.4),
                            radius: 4,
                            x: 0,
                            y: 2
                        )
                        .frame(width: 80.0, alignment: .center)
                    Slider(
                        value: $angle,
                        in: 0...360
                    )
                    .tint(LinearGradient.appPrimaryInverse)
                }
                HStack {
                    Text("Blur")
                        .font(.system(
                            size: 14,
                            design: .monospaced
                        ))
                        .foregroundStyle(textColor)
                        .shadow(
                            color: .black.opacity(0.4),
                            radius: 4,
                            x: 0,
                            y: 2
                        )
                        .frame(width: 80.0, alignment: .center)
                    Slider(
                        value: $blurAmount,
                        in: 0...50
                    )
                    .tint(LinearGradient.appPrimaryInverse)
                }
            }
            .offset(y: 280.0)
            .padding()
        }
    }
}

#Preview {
    CircleView()
        .preferredColorScheme(.dark)
}
