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
    
    var body: some View {
  
                    List {
                        ForEach(summaries) { summary in
                            NavigationLink(destination: HistoryDetailView(summary: summary)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(summary.summaryText)
                                        .lineLimit(2)
                                        .font(.headline)
                                    
                                    Text("Total prompts: \(summary.logPrompts.count)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onDelete { indexSet in
                                for index in indexSet {
                                    let summary = summaries[index]
                                    modelContext.delete(summary)
                                }
                            }
                    }
                    .navigationTitle("Histori Curhat")
                }

}

extension SummaryRecord {
    static var preview: SummaryRecord {
        let logs = [
            LogPrompt(userText: "Aku capek banget hari ini", modelResponse: "Capeknya karena apa tuh? Cerita dong."),
            LogPrompt(userText: "Banyak tugas kuliah", modelResponse: "Wajar sih kalau lagi banyak tugas bisa kerasa berat.")
        ]
        return SummaryRecord(summaryText: "Kamu cerita soal kelelahan karena kuliah dan tugas-tugas yang numpuk.", logPrompts: logs)
    }
}


#Preview {
    do {
            let container = try ModelContainer(for: SummaryRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            let context = container.mainContext

            // Insert dummy data
            let record = SummaryRecord.preview
            context.insert(record)

            return HistoryListView()
                .modelContainer(container)
        } catch {
            return Text("Failed to load preview: \(error.localizedDescription)")
        }
}
