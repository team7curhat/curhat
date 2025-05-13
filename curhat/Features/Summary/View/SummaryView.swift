//
//  SummaryView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 06/05/25.
//

import SwiftUI
import Lottie
struct SummaryView: View {
    @Binding var shouldPopToRootView : Bool
    let summary: String
    @StateObject private var promptManager = PromptManager()
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Background that extends to all edges
                Color("primary-1")
                    .edgesIgnoringSafeArea(.all)
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            ZStack(alignment: .center) {
                                Image("summary-bg")
                                    .resizable()
                                    .scaledToFit()
                                
                                Text("Dari cerita yang aku dengar darimu,")
                                    .multilineTextAlignment(.leading)
                                    .frame(width: 130, height: 100)
                                    .offset(x: -100, y: -280)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("primary-9"))
                                    .font(.body)
                                
                                ScrollView {
                                    Text("\(summary)").foregroundStyle(Color("primary-6")).fontWeight(.medium)
                                }
                                .frame(maxHeight: 400)
                                .padding(.top, 150)
                                .padding(.horizontal, 50)
                            }.padding(.horizontal, 12)
                            
                            Button(action: {
                                withAnimation {
                                    proxy.scrollTo("_bottom", anchor: .bottom)
                                }
                            }){
                                VStack(alignment: .center, spacing: 10) {
                                    Text("Scroll ke bawah")
                                        .foregroundStyle(Color("primary-6")).fontWeight(.medium)
                                        .font(.caption)
                                    Image(systemName: "chevron.down")
                                        .foregroundStyle(Color("primary-7"))
                                }
                                .padding(.top, 16)
                            }
                            
                            
                            
                            VStack(alignment: .center, spacing:36) {
                                Text("Bagaimana perasaanmu sekarang setelah bercerita?")
                                    .foregroundStyle(Color("primary-6"))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .padding(.top,75)
                                    .frame(width: 250, height: 180)
                                HStack(alignment: .center, spacing:36) {
                                    
                                  
                                    NavigationLink(destination: StoryView(emotionName: "senang").navigationBarBackButtonHidden(true)) {
                                        VStack(alignment: .center, spacing:0) {
                                            Image("mau cerita lagi").resizable().scaledToFit().frame(width: 150, height: 150)
                                            Text("Butuh cerita lagi")
                                                .foregroundStyle(Color("primary-6"))
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                    
                                    NavigationLink(destination: HomeView().navigationBarBackButtonHidden(true)) {
                                        VStack(alignment: .center, spacing:0) {
                                            Image("lega").resizable().scaledToFit().frame(width: 150, height: 150)
                                            Text("Lebih lega")
                                                .foregroundStyle(Color("primary-6"))
                                                .font(.title2)
                                                .fontWeight(.bold)
                                            .multilineTextAlignment(.center) }
                                    }
                                    
                                    
                                    
                                }
                                Image("bg-summary")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.top, 100)
                                    .id("_bottom")
                            }
                        }.padding(.top, 60)
                        
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea(.all, edges: [.top, .bottom]) // Ignore safe areas to extend content fully
            .onAppear {
                promptManager.logPrompts.removeAll()
            }
        }
    }
}

#Preview {
    SummaryView(shouldPopToRootView: .constant(false),summary: "Lorem ipsum dolor sit amet consectetur. Imperdiet donec ullamcorper purus diam pharetra tortor. Ultrices tincidunt pulvinar morbi tempor. Ultricies aenean et facilisi pellentesque odio orci. Quam velit non amet amet phasellus at eu lectus quam. Senectus tristique scelerisque in sagittis aliquam. Gravida rhoncus quam viverra porttitor donec aliquet. Elementum aliquet ut donec turpis malesuada dictum. Nunc ac proin dolor purus enim. Nunc amet volutpat phasellus ornare velit enim nec.Lorem ipsum dolor sit amet consectetur. Imperdiet donec ullamcorper purus diam pharetra tortor. Ultrices tincidunt pulvinar morbi tempor. Ultricies aenean et facilisi pellentesque odio orci. Quam velit non amet amet phasellus at eu lectus quam. Senectus tristique scelerisque in sagittis aliquam. Gravida rhoncus quam viverra porttitor donec aliquet. Elementum aliquet ut donec turpis malesuada dictum. Nunc ac proin dolor purus enim. Nunc amet volutpat phasellus ornare velit enim nec." )
}
