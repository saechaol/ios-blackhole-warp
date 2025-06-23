//
//  MotionManager.swift
//  ImageWarp
//
//  Created by 세차오 루카스 on 6/22/25.
//

import CoreMotion
import Combine

class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    private var isBaselineSet = false
    private let updateInterval = 1.0 / 60.0
    
    @Published private(set) var rawPitch: Double = 0.0
    @Published private(set) var rawYaw: Double = 0.0
    @Published private(set) var rawRoll: Double = 0.0
    
    // baseline offsets to reset zero point
    private var baselinePitch: Double = 0.0
    private var baselineYaw: Double = 0.0
    private var baselineRoll: Double = 0.0 
    
    init() {
        startMotionUpdates()
    }
    
    private func startMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = updateInterval
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let motion = motion else { return }
            
            self?.rawPitch = motion.attitude.pitch
            self?.rawYaw = motion.attitude.yaw
            self?.rawRoll = motion.attitude.roll
        }
        
        // Reset baseline when we get first valid data
        if !self.isBaselineSet {
            self.resetBaseline()
            self.isBaselineSet = true 
        }
    }
    
    func resetBaseline() {
        baselinePitch = rawPitch
        baselineYaw = rawYaw
        baselineRoll = rawRoll
    }
    
    private func radiansToDegrees(_ radians: Double) -> Double {
        radians * 180 / .pi
    }
    
    var pitchDeg: Double {
        radiansToDegrees(pitchRad)
    }
    
    var yawDeg: Double {
        radiansToDegrees(yawRad)
    }
    
    var rollDeg: Double {
        radiansToDegrees(rollRad)
    }
    
    var pitchRad: Double {
        rawPitch - baselinePitch
    }
    
    var yawRad: Double {
        rawYaw - baselineYaw
    }
    
    var rollRad: Double {
        rawRoll - baselineRoll
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}
