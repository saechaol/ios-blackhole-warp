//
//  MetalView.swift
//  ImageWarp
//
//  Created by 세차오 루카스 on 6/21/25.
//

import SwiftUI

struct MetalView: View {
    @StateObject private var motion = MotionManager()
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            TabView {
                Tab("Circle", systemImage: "circle.fill") {
                    CircleView(motion: motion, size: size)
                }
                Tab("Picture", systemImage: "photo.fill") {
                    ImageView(motion: motion)
                }
            }
            .tint(.appPrimary)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview("Dark Mode") {
    MetalView()
        .preferredColorScheme(.dark)
}

#Preview("Light Mode") {
    MetalView()
        .preferredColorScheme(.light)
}
