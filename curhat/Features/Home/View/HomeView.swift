//
//  HomeView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 06/05/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedFilter: String = "Semua"
    let filters = ["Semua", "Marah", "Kecewa"]
    let history = [
        ("Marah", "05 Mei 2025", "20:00"),
        ("Senang", "05 Mei 2025", "20:00"),
        ("Kecewa", "05 Mei 2025", "20:00")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 20)
            
            // Greeting
            Text("Selamat pagi, Budi!")
                .font(.title2).bold()
                .padding(.bottom, 20)
            
            // Character face
            Image(systemName: "happy") // Use custom images or system icons
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding()
                .background(Color.gray.opacity(0.3))
                .clipShape(Circle())
                .onTapGesture {}
            
            Text("*Ketuk untuk bercerita")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 4)
                .padding(.bottom, 20)
            
            // Riwayat section
            HistorySection(selectedFilter: $selectedFilter, filters: filters, history: history)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Emochi")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(.black)
            }
        }
    }
}


struct HistorySection: View {
    @Binding var selectedFilter: String
    let filters: [String]
    let history: [(emotion: String, date: String, time: String)]
    
    var filteredHistory: [(String, String, String)] {
        if selectedFilter == "Semua" {
            return history
        } else {
            return history.filter { $0.0 == selectedFilter }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Riwayat")
                .font(.headline)
            
            // Filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: {
                            selectedFilter = filter
                        }) {
                            Text(filter)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    selectedFilter == filter ?
                                    Color(UIColor.systemGray3) :
                                    Color(UIColor.systemGray5)
                                )
                                .foregroundColor(.black)
                                .clipShape(Capsule())
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundColor(.black)
                }
            }
            .padding(.bottom, 8)
            
            // History list
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(filteredHistory, id: \.0) { emotion in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(emotion.1)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(emotion.2)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                Text(emotion.0)
                                    .font(.headline)
                            }
                            Spacer()
                            Circle()
                                .fill(Color(UIColor.systemGray4))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.black)
                                )
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.4))
        .cornerRadius(30)
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
}

