//
//  GeminiModel.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 07/05/25.
//

import Foundation
import GoogleGenerativeAI

let APIKey = "AIzaSyC43lOuw4L-dUHF52uDz5DvuyY2DlH3ROA"
final class GeminiModel {
  static let shared = GeminiModel()

  let generativeModel: GenerativeModel

  private init() {
    self.generativeModel = GenerativeModel(
      name: "gemini-2.0-flash",
      apiKey: APIKey
    )
  }
}
