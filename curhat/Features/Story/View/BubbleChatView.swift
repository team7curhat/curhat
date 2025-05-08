//
//  BubbleChatView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 07/05/25.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct BubbleChatView: View {
    let message: String
    let isKeyboardActive: Bool
    
    var body: some View {
        ZStack(alignment: isKeyboardActive ? .topLeading : .bottom) {
            // 1. The “tail”:
            Triangle()
                .fill(Color("bubble-chat"))
                .frame(width: 30, height: 20)
                .overlay(
                    Triangle()
                        .stroke(Color("primary-2"), lineWidth: 1)
                )
                .rotationEffect(.degrees(isKeyboardActive ? 50 : 180))
                .offset(x: 0, y: isKeyboardActive ? 5 : 10)
            
            // 2. The bubble content:
            ScrollView {
                Text(message)
                    .font(.headline)
                    .foregroundColor(Color("primary-7"))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            // 3. Constrain to at most 5 lines tall:
            .frame(maxHeight: maxBubbleHeight)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("bubble-chat"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("primary-2"), lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            
            Rectangle()
                .fill(Color("bubble-chat"))
                .frame(width: 25, height: 3)
                .offset(x: 0, y: -2) // Adjust these values to position the triangle
            
            Rectangle()
                .fill(Color("bubble-chat"))
                .frame(width: 3, height:18)
                .offset(x: 15, y: 10)
            
        }
    }
    
    /// Compute five lines + vertical padding.
    private var maxBubbleHeight: CGFloat {
        let lineHeight = UIFont.preferredFont(forTextStyle: .body).lineHeight
        let maxLines: CGFloat = 5
        let verticalPadding: CGFloat = 12 * 2   // top + bottom padding on Text
        return (lineHeight * maxLines) + verticalPadding
    }
}
#Preview {
    BubbleChatView(message:"""
[IMPORTANT] dear all - as I mentioned, untuk script dan storyboard is expected udah kalian mulai develop untuk production app/game video demo yg akan dishowcase di hari Rabu depan (14 mei). 

untuk kelancaran di hari H, all teams are REQUIRED untuk mengupload final video dan Hi-Fid app/game kalian paling lambat hari Selasa (13 Mei) jam 23.59 WIB via link ini
""", isKeyboardActive: false)
}
