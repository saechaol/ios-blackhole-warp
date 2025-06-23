//
//  ImageWarpView.swift
//  ImageWarp
//
//  Created by 세차오 루카스 on 6/22/25.
//

import SwiftUI
import PhotosUI

struct ImageView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var imageData: Data? = nil
    @State private var imageSize = CGSize(width: 360, height: 360)
    
    @ObservedObject var motion: MotionManager
    
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
            VStack {
                
                if let data = imageData,
                   let uiImage = UIImage(data: data) {
                    WarpedImageView(uiImage: uiImage,
                                    imageSize: imageSize,
                                    motion: motion)
                    .padding()
                } else {
                    Text("No image selected")
                        .font(.system(size: 18, design: .rounded))
                        .foregroundStyle(textColor)
                        .shadow(
                            color: .black.opacity(0.4),
                            radius: 4,
                            x: 0,
                            y: 2
                        )
                        .padding()
                }
                
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label("Select an image", systemImage: "photo.fill")
                        .font(.system(size: 18, design: .rounded))
                        .foregroundStyle(textColor)
                        .shadow(
                            color: .black.opacity(0.4),
                            radius: 4,
                            x: 0,
                            y: 2
                        )
                        .padding()
                }
                .onChange(of: selectedItem) { oldItem, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            imageData = data
                        }
                    }
                }
                
            }

        }
    }
    
}

#Preview {
    ImageView(motion: MotionManager())
        .preferredColorScheme(.light)
}
