//
//  TopWaveMask.swift
//  curhat
//
//  Created by Sakti Pardano on 08/05/25.
//

import SwiftUI

struct TopWaveMask: Shape {
    var phase: CGFloat
    var amplitude: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height
        let wavelength = width / 6

        // Start from bottom left
        path.move(to: CGPoint(x: 0, y: height))

        // Go up left side
        path.addLine(to: CGPoint(x: 0, y: height * 0.3))

        // Draw wave along the top edge
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / wavelength
            let y = height * 0.3 + sin(relativeX + phase) * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }

        // Down right side to bottom right
        path.addLine(to: CGPoint(x: width, y: height))

        // Close the path
        path.closeSubpath()

        return path
    }

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
}
