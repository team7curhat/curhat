//
//  AwarenessView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 06/05/25.
//

import SwiftUI

import SwiftUI

struct AwarenessView: View {
    @State private var selectedEmotion: String? = nil
    let emotions = ["Sedih", "Marah", "Takut", "Senang", "Terkejut", "Malu"]
    let images = ["sad", "angry", "scared", "happy", "surprised", "shy"] 

    var body: some View {
        VStack {
            Text("Kamu lagi ngerasain apa hari ini?")
                .font(.title2)
                .bold()
                .padding(.top, 20)
            
            // Emotion Grid
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                ForEach(emotions.indices, id: \.self) { index in
                    EmotionButton(
                        emotion: emotions[index],
                        isSelected: selectedEmotion == emotions[index],
                        imageName: images[index]
                    ) {
                        selectedEmotion = emotions[index]
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Awareness")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Akhiri") {
                    // End action
                }
            }
        }
    }
}

struct EmotionButton: View {
    let emotion: String
    let isSelected: Bool
    let imageName: String
    var action: () -> Void

    var body: some View {
        VStack {
            Image(systemName: imageName) // Use custom images or system icons
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .padding()
                .background(
                    isSelected ? Color.orange : Color.gray.opacity(0.3)
                )
                .clipShape(Circle())
                .onTapGesture {
                    action()
                }

            Text(emotion)
                .font(.caption)
                .foregroundColor(.black)
        }
        .animation(.easeInOut, value: isSelected)
    }
}

#Preview {
    NavigationView {
        AwarenessView()
    }
}

