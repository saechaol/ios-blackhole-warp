//
//  WarpedImageView.swift
//  ImageWarp
//
//  Created by 세차오 루카스 on 6/22/25.
//

import SwiftUI

struct WarpedImageView: View {
    @Environment(\.colorScheme) var colorScheme
    let uiImage: UIImage
    let imageSize: CGSize
    
    @State private var currentWarpFactor: Double = 1.0
    @State private var currentIntensity: Double = 0.0
    
    @State private var warpFactor: Double = 0.0
    @State private var intensity: Double = 0.0
    
    @ObservedObject var motion: MotionManager
    
    var textColor: some ShapeStyle {
        if colorScheme == .dark {
            return Color.white
        } else {
            return Color.white
        }
    }
    
    
    private func mappedPosition(from motion: MotionManager, in size: CGSize) -> CGPoint {
        let limit = Double.pi / 12.0
        
        let clampedRoll = min(max(motion.rollRad, -limit), limit)
        let clampedPitch = min(max(motion.pitchRad, -limit), limit)
        
        let normalizedX = (clampedRoll + limit) / (2 * limit)
        let normalizedY = (clampedPitch + limit) / (2 * limit)
        
        let circleRadius = 100.0
        let overshoot = 50.0
        
        let extendedWidth = size.width + 2 * (circleRadius + overshoot)
        let extendedHeight = size.height + 2 * (circleRadius + overshoot)
        let x = normalizedX * extendedWidth - (circleRadius + overshoot)
        let y = normalizedY * extendedHeight - (circleRadius + overshoot)
        
        return CGPoint(x: x, y: y)
    }
    
    func easeInOut(_ normalized: Double, pivot: Double) -> Double {
        if normalized < pivot {
            // slow rise
            return pow(normalized / pivot, 2) * 0.5
        } else {
            let remainder = (normalized - pivot) / (1.0 - pivot)
            return 0.5 + (1 - pow(1 - remainder, 2)) * 0.5
        }
    }
    
    var body: some View {
        let position = mappedPosition(from: motion, in: imageSize)
        ZStack {
            Color.clear
                .contentShape(Rectangle()) // Ensure tap/drag area covers full screen
                .gesture(
                    DragGesture(minimumDistance: 0.0)
                        .onChanged { value in
                            let delta = value.translation.width
                            let screenWidth = UIScreen.main.bounds.width
                            let deltaNormalized = delta / screenWidth
                            intensity = min(max(currentIntensity + deltaNormalized, 0.0), 1.0)
                        }
                        .onEnded { _ in
                            currentIntensity = intensity
                        }
                )
                .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            motion.resetBaseline()
                        }
                )
            ZStack {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize.width, height: imageSize.height)
                    .compositingGroup()
                    .layerEffect(
                        ShaderLibrary.warp(
                            .float2(imageSize),
                            .float2(position),
                            .float(warpFactor),
                            .float(intensity)
                        ), maxSampleOffset: CGSize(width: imageSize.width, height: imageSize.height)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .frame(width: imageSize.width, height: imageSize.height)
            .contentShape(Rectangle())
            .highPriorityGesture(
                MagnificationGesture()
                    .onChanged { value in
                        warpFactor = min(max(0.0, currentWarpFactor * value), 5.0)
                    }
                    .onEnded { _ in
                        currentWarpFactor = warpFactor
                    }
            )
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        motion.resetBaseline()
                    }
            )

        }
    }
}

#Preview("ImageView") {
    @Previewable @State var pos = CGPoint(x: 100, y: 100)
    @Previewable @State var warp = 2.0
    @Previewable @State var intensity = 0.5
    
    let sampleImage = UIImage(named: "WWDC") ?? UIImage(systemName: "circle.fill")!
    WarpedImageView(
        uiImage: sampleImage,
        imageSize: CGSize(width: 300, height: 300),
        motion: MotionManager()
    )
    .preferredColorScheme(.dark)
}
