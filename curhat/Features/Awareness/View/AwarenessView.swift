//
//  AwarenessView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 06/05/25.
//

import SwiftUI


struct AwarenessView: View {
    @State private var selectedEmotion: String? = nil
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack() {
                Text("Kamu lagi ngerasain apa hari ini?")
                    .font(.title)
                    .bold()
                    .padding(.top, 10)
                    .padding(.bottom, 24)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Emotion Grid
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                    
                    ForEach(listEmotions.dropLast(listEmotions.count % 2)) { emotion in
                        
                        NavigationLink(destination: StoryView(emotionName: emotion.name).navigationBarBackButtonHidden(true)) {
                            EmotionButton(
                                emotion: emotion.label,
                                isSelected: selectedEmotion == emotion.name,
                                imageName: emotion.imageString
                            ) {
                                selectedEmotion = emotion.name
                            }
                        }
                    }
                }
                
                LazyHStack {
                    ForEach(listEmotions.suffix(listEmotions.count % 2)) { emotion in
                        
                        NavigationLink(destination: StoryView(emotionName: emotion.name).navigationBarBackButtonHidden(true)) {
                            EmotionButton(
                                emotion: emotion.label,
                                isSelected: selectedEmotion == emotion.name,
                                imageName: emotion.imageString
                            ) {
                                selectedEmotion = emotion.name
                            }
                        }
                          
                        
                        
                    }
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "chevron.backward").foregroundColor(Color.primary6)
                            }
                        }
                    }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    //backbutton
//                    NavigationLink(destination: HomeView()) {
//                        Image(systemName: "chevron.backward").foregroundColor(Color.primary6)
//                    }
//                }
////                ToolbarItem(placement: .navigationBarTrailing) {
////                    Image(systemName: "speaker.wave.2.fill").foregroundColor(Color.primary6)
////                }
//            }
//            .navigationBarBackButtonHidden(true)
        
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
                Image(imageName) // Use custom images or system icons
                    .resizable()
                    .scaledToFit()
                    .frame(width: 128, height: 93)
                    .padding(.bottom, 15)
                    

                Text(emotion)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .animation(.easeInOut, value: isSelected)
        }
        
    
}

#Preview {
  
        AwarenessView()
    
}

