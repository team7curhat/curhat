//
//  HistoryDetailView.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 16/05/25.
//
import SwiftUI

struct HistoryDetailView: View {
    let summary: SummaryRecord

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Ringkasan Cerita")
                    .font(.title2)
                    .bold()
                Text(summary.summaryText)
                    .font(.body)

                Divider()

                Text("Percakapan")
                    .font(.title2)
                    .bold()

                ForEach(summary.logPrompts, id: \.self) { log in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("🧍‍♂️ Kamu:")
                            .fontWeight(.semibold)
                        Text(log.userText)
                            .padding(.bottom, 8)

                        Text("🤖 Ochi:")
                            .fontWeight(.semibold)
                        Text(log.modelResponse)
                            .padding(.bottom, 16)

                        Divider()
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Detail Cerita")
    }
}

//#Preview {
//    HistoryDetailView(summary: [])
//}
