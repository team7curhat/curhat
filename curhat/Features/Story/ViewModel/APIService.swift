//
//  APIService.swift
//  curhat
//
//  Created by Melki Jonathan Andara on 01/01/26.
//

import SwiftUI
import Alamofire

struct GenerateRequest: Encodable {
    let logPrompts: String
    let userPrompt: String
    let nickname: String
}

struct GenerateResponse: Decodable {
    let expression: String
    let follow_up_question: String
    let feedback: String
}
enum APIError: Error {
    case requestFailed(String)
    case decodingFailed
}

class APIService: ObservableObject {
    static let shared = APIService()
    
    private init (){}
    
    var url = "https://api.heymejo.online/"
    
    func generateResponse(generateRequest: GenerateRequest) async throws -> GenerateResponse {
            let parameters: [String: String] = [
                "logPrompts": generateRequest.logPrompts,
                "userPrompt": generateRequest.userPrompt,
                "nickname": generateRequest.nickname
            ]
        var responseUrl = url + "/generate"
            
            return try await withCheckedThrowingContinuation { continuation in
                AF.request(
                    responseUrl,
                    method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default,
                    headers: ["Content-Type": "application/json"]
                )
                .validate()
                .responseDecodable(of: GenerateResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: APIError.requestFailed(error.localizedDescription))
                    }
                }
            }
        }
    
    func generateSummary(generateRequest: GenerateRequest) async throws -> String{
        let parameters: [String: String] = [
            "logPrompts": generateRequest.logPrompts,
            "userPrompt": generateRequest.userPrompt,
            "nickname": generateRequest.nickname
        ]
        var responseUrl = url + "/summary"
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                responseUrl,
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: ["Content-Type": "application/json"]
            )
            .validate()
            .responseDecodable(of: String.self) { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: APIError.requestFailed(error.localizedDescription))
                }
            }
        }
    }
}
