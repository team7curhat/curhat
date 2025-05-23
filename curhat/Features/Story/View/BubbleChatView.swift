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
    let followUp: String
    let isKeyboardActive: Bool
    
    var body: some View {
        ZStack(alignment: isKeyboardActive ? .topLeading : .bottom) {
            // 1. The “tail”:
            Triangle()
                .fill(Color("primary-1"))
                .frame(width: 30, height: 20)
                .overlay(
                    Triangle()
                        .stroke(Color("primary-3"), lineWidth: 1)
                )
                .rotationEffect(.degrees(isKeyboardActive ? 50 : 180))
                .offset(x: 0, y: isKeyboardActive ? 25 : 10)
            
            // 2. The bubble content:
            ScrollView {
                Text("\(message) \(followUp)")
                    .font(.headline)
                    .foregroundColor(Color("primary-6"))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            // 3. Constrain to at most 5 lines tall:
            .frame(maxHeight: 100)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("primary-1"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("primary-3"), lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            
            Rectangle()
                .fill(Color("primary-1"))
                .opacity(isKeyboardActive ? 0 : 1)
                .frame(width: 18, height: 3)
                .offset(x: 0, y: -2)
            
            Rectangle()
                .fill(Color("primary-1"))
                .opacity(isKeyboardActive ? 1 : 0)
                .frame(width: 4, height: 19)
                .offset(x: 14, y: 30)
            
        }
    }
    
    /// Compute five lines + vertical padding.
//    private var maxBubbleHeight: CGFloat {
//        let lineHeight = UIFont.preferredFont(forTextStyle: .body).lineHeight
//        let maxLines: CGFloat = 5
//        let verticalPadding: CGFloat = 12 * 1  // top + bottom padding on Text
//        return 120
//    }
}
#Preview {
    BubbleChatView(message:"""
[IMPORTANT] dear all - as I mentioned, untuk script dan storyboard is expected udah kalian mulai develop untuk production app/game video demo yg akan dishowcase di hari Rabu depan (14 mei). 

untuk kelancaran di hari H, all teams are REQUIRED untuk mengupload final video dan Hi-Fid app/game kalian paling lambat hari Selasa (13 Mei) jam 23.59 WIB via link ini
""",followUp: "Halo", isKeyboardActive: false)
}
