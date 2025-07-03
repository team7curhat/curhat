//
//  HistoryListView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 13/05/25.
//

import SwiftUI
import SwiftData

struct HistoryListView: View {
    @Query var summaries: [SummaryRecord]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    private let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()
    
    var body: some View {
        List {
            ForEach(summaries) { summary in
                NavigationLink(destination: HistoryDetailView(summary: summary)) {
                    VStack(alignment: .leading){
                        HStack(alignment: .center, spacing: 12) {
                            VStack{
                                Text(dateFormatter.string(from: summary.createdAt))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color("primary-1"))
                                Text(monthYearFormatter.string(from: summary.createdAt))
                                    .font(.caption2)
                                    .foregroundStyle(Color("primary-1"))
                            }
                            .frame(width:50, height:50)
                            .foregroundColor(.white)
                            .background(Color("primary-9"))
                            .cornerRadius(8)
                            
                            
                            
                            Text(summary.summaryText)
                                .lineLimit(3)
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundStyle(Color("body-text"))
                                .multilineTextAlignment(.leading)
                            
                            
                        }
                    }
                    
                    
                    
                }
                
                
                .padding(.horizontal, 14)
                .padding(.vertical,12)
                .background(Color("primary-1"))
                .cornerRadius(10)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let summary = summaries[index]
                    modelContext.delete(summary)
                }
            }
        }
        .navigationTitle("Daftar cerita")
        .foregroundStyle(.white)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color("bg-custom"))
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading){
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color("primary-6"))
                        .font(.system(size: 17, weight: .semibold))
                }
            }
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    for record in summaries {
                                modelContext.delete(record)
                            }
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(Color("primary-6"))
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
    }
    
    
    
}

extension SummaryRecord {
    static var preview: SummaryRecord {
        let logs = [
            LogPrompt(userText: "Aku capek banget hari ini", modelResponse: "Capeknya karena apa tuh? Cerita dong."),
            LogPrompt(userText: "Banyak tugas kuliah", modelResponse: "Wajar sih kalau lagi banyak tugas bisa kerasa berat.")
        ]
        return SummaryRecord(summaryText: "Kamu cerita soal kelelahan karena kuliah dan tugas-tugas yang numpuk. dan kenapa kamu pergi kemapus", logPrompts: logs)
    }
}


#Preview {
    do {
        let container = try ModelContainer(for: SummaryRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = container.mainContext
        
        // Insert dummy data
        let record = SummaryRecord.preview
        context.insert(record)
        
        return NavigationStack {
            HistoryListView()
        }
        .modelContainer(container)
    } catch {
        return Text("Failed to load preview: \(error.localizedDescription)")
    }
}
