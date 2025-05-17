//
//  PopoverView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 17/05/25.
//

import SwiftUI

struct PopoverView: View {
    @State private var isShowingPopover = false
    var body: some View {
      VStack {
          Button(action: { self.isShowingPopover = true}) {
              Image(systemName: "info.circle")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 18, height: 18)
                  .foregroundStyle(Color("primary-6"))
                  }
                  .popover(
                      isPresented: $isShowingPopover, arrowEdge: .top
                  ) {
                      VStack {
                          HStack(alignment:.center, spacing: 0) {
                              
                              Text("Shake phone ")
                                  .fontWeight(.bold)
                              Text("to change question")
                          }
                          .font(.caption)
                          
                      }
                      .padding(.horizontal,12)
                      .presentationCompactAdaptation((.popover))
                  }
        }
    }
}

#Preview {
    PopoverView()
}
