//
//  RecentHistoryView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 18/05/25.
//
import SwiftUI
import SwiftData

struct RecentHistoryView: View {
    @Query(sort: \SummaryRecord.createdAt, order: .reverse) var summaries: [SummaryRecord]
    @Environment(\.modelContext) private var modelContext
    

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
           
            
            if let mostRecent = summaries.first {
                let date = mostRecent.createdAt
                let day = Calendar.current.component(.day, from: date)
                let monthName = monthIndonesian(from: date)
                
               
                
                VStack(alignment: .leading, spacing: 4){
                    Text("Your latest story!")
                        .font(.body)
                        .fontWeight(.bold)
                    NavigationLink(destination: HistoryDetailView(summary: mostRecent)) {
                        HStack(alignment: .center, spacing: 8) {
                            VStack(alignment: .center) {
                                Text("\(day)")
                                    .font(.subheadline)
                                    .foregroundStyle(Color("primary-1"))
                                Text(monthName)
                                    .font(.caption)
                                    .foregroundStyle(Color("primary-1"))
                            }
                            .frame(width:45, height: 45)
                            .background(Color("primary-9"))
                            .foregroundStyle(.white)
                            .cornerRadius(6)
                            
                            VStack(alignment: .leading){
                                // Display first part of summary as title (up to first period)
                                Text(getFirstSentence(from: mostRecent.summaryText))
                                    .foregroundStyle(Color("primary-9"))
                                    .font(.caption)
                                    .lineLimit(1)
                                // Display the full summary as content
                                Text(mostRecent.summaryText)
                                    .font(.caption2)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            ZStack {
                                Circle()
                                    .fill(Color("primary-9"))
                                    .frame(width: 28, height: 28)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color("primary-1"))
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color("primary-1"))
                        .cornerRadius(12)
                    }
                    
                    NavigationLink(destination: HistoryListView()) {
                        HStack(alignment: .center) {
                            Text("View more stories").font(.caption2).fontWeight(.bold).foregroundStyle(Color("primary-1"))
                            Spacer()
                            Image(systemName: "arrow.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width:16, height:16)
                                .foregroundStyle(Color("primary-1"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 11)
                        .background(Color("primary-9"))
                        .cornerRadius(6)
                    }
                    .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
    
    // Helper function to get Indonesian month name
    private func monthIndonesian(from date: Date) -> String {
        let month = Calendar.current.component(.month, from: date)
        let indonesianMonths = ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des"]
        return indonesianMonths[month - 1]
    }
    
    // Helper function to get first sentence for the title
    private func getFirstSentence(from text: String) -> String {
        let sentences = text.components(separatedBy: ".")
        if let first = sentences.first, !first.isEmpty {
            return first + "."
        }
        return text
    }
}

