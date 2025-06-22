//
//  MetalView.swift
//  ImageWarp
//
//  Created by 세차오 루카스 on 6/21/25.
//

import SwiftUI

struct MetalView: View {
    var body: some View {
        TabView {
            Tab("Circle", systemImage: "circle.fill") {
                CircleView()
            }
            Tab("Picture", systemImage: "photo.fill") {
                ImageView()
            }
        }
        .tint(.appPrimary)
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
