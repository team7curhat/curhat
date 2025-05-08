//
//  StoryModel.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 06/05/25.
//
import Foundation

struct FeedbackResponse: Decodable {
    let expression: String
    let feedback: String
    let followUp: String
    
    enum CodingKeys: String, CodingKey {
        case expression
        case feedback
        case followUp = "follow_up_question"
    }
}
