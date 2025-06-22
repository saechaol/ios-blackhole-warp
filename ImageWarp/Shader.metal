//
//  Shader.metal
//  ImageWarp
//
//  Created by 세차오 루카스 on 6/22/25.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

[[ stitchable ]] half4 warp(
                           float2           position,
                           SwiftUI::Layer   layer,
                           float2           size,
                           float2           touchPoint,
                           float            warp,
                           float            intensity) {
    // take pixel screen coord, normalize it by dividing by size
    float2 uv = position / size;
    float2 touch = touchPoint / size;
    
    float touchToPixelDistance = length(uv - touch);
    float warpFactor = warp / 40;
    
    float inputScalingFactor = warpFactor * warpFactor * intensity * intensity;
    
    float displacementFactor = (0.5 - touchToPixelDistance);
    
    float2 displacement = displacementFactor * size * intensity;
    
    // nonlinear displacement
    float2 displacePosition = (position + exp(displacement * warpFactor * 2));
    
    // sample RGB at different offsets
    // create chromatic abberration effect
    half3 f = half3(
                    layer.sample(displacePosition + inputScalingFactor * intensity).r,
                    layer.sample(displacePosition + inputScalingFactor * 0.1).g,
                    layer.sample(displacePosition + inputScalingFactor / 5).b
                    );
    
    // return the final color with alpha set to 1.0
    return half4(f, 1.0);
}

[[ stitchable ]] half4 light(
                             float2             position,
                             SwiftUI::Layer     layer,
                             float2             size,
                             float2             touchPoint,
                             float              angle) {
    // take pixel screen coord, normalize it by dividing by size
    float2 uv = position / size;
    float2 touch = touchPoint / size;
    float2 direction = uv - touch;
    float touchToPixelDistance = length(direction);
    float normalizedAngle = angle / 40;
    
    // compute how far color channels should be sampled
    float inputScalingFactor = normalizedAngle * normalizedAngle * 2;
    
    // how much to push the pixel's color based on distance to touch point
    float displacementFactor = 1.0 - (touchToPixelDistance * touchToPixelDistance) * normalizedAngle * 2;
    
    float2 displacePosition = position + position * displacementFactor * 2;
    
    // sample RGB at offset locations
    half3 rgb = half3(
                    layer.sample(displacePosition + inputScalingFactor).r,        // sample from stronger offset
                    layer.sample(displacePosition + inputScalingFactor * 0.2).g,  // sample from lighter offset
                    layer.sample(displacePosition - inputScalingFactor).b         // sample from opposing direction
                    );
    
    return half4(rgb, 1.0);
}
