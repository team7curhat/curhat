//
//  AnimatedTopWaveImage.swift
//  curhat
//
//  Created by Sakti Pardano on 08/05/25.
//

import SwiftUI

struct AnimatedTopWaveImage: View {
    
    var color: Color;
    var height: CGFloat;
    
    @State private var phase: CGFloat = 0
    
    var body: some View {
        
        color.mask(
                TopWaveMask(phase: phase, amplitude: 12)
            )
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    phase = .pi * 2
                }
            }
            .frame(maxWidth:.infinity, maxHeight: height)
            .ignoresSafeArea()
        
            
    }
}
