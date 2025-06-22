//
//  LinearGradient+Extensions.swift
//  ImageWarp
//
//  Created by 세차오 루카스 on 6/22/25.
//

import SwiftUI

extension LinearGradient {
    static let appPrimary = LinearGradient(
        colors: [Color.appPrimary, Color.appSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let appPrimaryInverse = LinearGradient(
        colors: [Color.appPrimary, Color.appSecondary],
        startPoint: .bottomTrailing,
        endPoint: .topLeading
    )
    
    static let subjectPrimaryDark = LinearGradient (
        colors: [Color.subjectDarkPrimary, Color.subjectDarkSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let subjectPrimaryLight = LinearGradient (
        colors: [Color.subjectLightPrimary, Color.subjectLightPrimary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
