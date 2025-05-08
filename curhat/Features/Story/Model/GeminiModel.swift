//
//  GeminiModel.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 07/05/25.
//

import Foundation
import GoogleGenerativeAI
final class GeminiModel {
  static let shared = GeminiModel()

  let generativeModel: GenerativeModel

  private init() {
    self.generativeModel = GenerativeModel(
      name: "gemini-1.5-flash",
      apiKey: APIKey.default
    )
  }
}
