//
//  CircleView.swift
//  ImageWarp
//
//  Created by 세차오 루카스 on 6/22/25.
//

import SwiftUI

struct CircleView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var motion: MotionManager
    
    let size: CGSize
    
    var circlePrimaryColor: some ShapeStyle {
        colorScheme == .dark ? LinearGradient.subjectPrimaryDark : LinearGradient.subjectPrimaryLight
    }
    
    var textColor: some ShapeStyle {
        Color.white
    }
    
    var blurAmount: Double {
        let pitchDegrees = motion.pitchDeg
        let maxRotation = 30.0
        let clampedPitch = min(max(pitchDegrees, -maxRotation), maxRotation)
        
        let distanceFromZeroPoint = abs(clampedPitch)
        let normalized = distanceFromZeroPoint / maxRotation
        let easedNormalized = easeInOut(normalized, pivot: 0.3)
        
        return easedNormalized * 25.0
    }
    
    var angle: Double {
        let pitchDegrees = motion.pitchDeg
        let maxRotation = 15.0
        let clampedPitch = min(max(pitchDegrees, -maxRotation), maxRotation)
        
        let distanceFromZeroPoint = abs(clampedPitch)
        
        let normalized = distanceFromZeroPoint / maxRotation
        let easedNormalized = easeInOut(normalized, pivot: 0.3)
        return easedNormalized * 180
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
        let position = mappedPosition(from: motion, in: size)
        
        ZStack {
            LinearGradient.appPrimary
                .ignoresSafeArea()

            Circle()
                .fill(circlePrimaryColor)
                .frame(width: 200, height: 200)
                .blur(radius: blurAmount)
                .layerEffect(
                    ShaderLibrary.light(
                        .float2(size),
                        .float2(position),
                        .float(angle)
                    ), maxSampleOffset: CGSize(width: size.width, height: size.height)
                )
                .position(position)
            
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .onTapGesture {
            motion.resetBaseline()
        }
    }
}


#Preview {
    CircleView(motion: MotionManager(), size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        .preferredColorScheme(.dark)
}
