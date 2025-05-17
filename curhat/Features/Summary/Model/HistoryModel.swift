//
//  HistoryModel.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 16/05/25.
//

import Foundation
import SwiftData

@Model
class SummaryRecord : Identifiable {
    var id = UUID()
    var summaryText: String
    var logPrompts: [LogPrompt]
    var createdAt = Date ()

    init(summaryText: String, logPrompts: [LogPrompt]) {
        self.summaryText = summaryText
        self.logPrompts = logPrompts
    }
}

@Model
class LogPrompt : Identifiable {
    var id = UUID()
    var userText: String
    var modelResponse: String
   

    init(userText: String, modelResponse: String) {
        self.userText = userText
        self.modelResponse = modelResponse
       
    }
}
