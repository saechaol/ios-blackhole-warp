//
//  ImageWarpView.swift
//  ImageWarp
//
//  Created by 세차오 루카스 on 6/22/25.
//

import SwiftUI

struct ImageView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var position = CGPoint(x: 180, y: 180)
    @State private var imageSize = CGSize(width: 360, height: 360)
    @State private var warpFactor: Double = 1
    @State private var intensity: Double = 0.5
    
    var textColor: some ShapeStyle {
        if colorScheme == .dark {
            return Color.white
        } else {
            return Color.white
        }
    }
    
    var body: some View {
        ZStack {
            Image("WWDC")
                .resizable()
                .frame(width: imageSize.width, height: imageSize.height)
                .scaledToFill()
                .layerEffect(
                    ShaderLibrary.warp(
                        .float2(imageSize),
                        .float2(position),
                        .float(warpFactor),
                        .float(intensity)
                    ), maxSampleOffset: CGSize(width: 320, height: 360)
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            position = value.location
                        }
                )
            
            VStack {
                Text("Warp: \(String(format: "%.2f", warpFactor)), Intensity: \(String(format: "%.2f", intensity))")
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
                    Text("Warp")
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
                        value: $warpFactor,
                        in: 0...5
                    )
                }
                
                HStack {
                    Text("Strength")
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
                        value: $intensity,
                        in: 0...1
                    )
                }
            }
            .offset(y: 280)
            .padding()
        }
    }
    
}

#Preview {
    ImageView()
        .preferredColorScheme(.light)
}
