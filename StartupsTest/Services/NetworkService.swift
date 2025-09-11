//
//  NetworkService.swift
//  StartupsTest
//
//  Created by Сергей on 07.09.2025.
//

import Foundation

protocol NetworkServiceProtocol {
  func sendIdTokenToBackend(_ idToken: String) async throws -> AuthResult
}

final class NetworkService: NetworkServiceProtocol {
  static let shared = NetworkService()
  private let baseURL = "https://api.court360.ai/rpc/client"
  
  func sendIdTokenToBackend(_ idToken: String) async throws -> AuthResult {
    let request = JSONRPCRequest(
      method: "auth.firebaseLogin",
      params: ["fbIdToken": idToken]
    )
    
    guard let url = URL(string: baseURL) else {
      throw URLError(.badURL)
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.timeoutInterval = 10
    urlRequest.httpBody = try JSONEncoder().encode(request)
    
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw URLError(.cannotParseResponse)
    }
    
    if httpResponse.statusCode == 521 {
      throw NSError(domain: "ServerError", code: 521, userInfo: [
        NSLocalizedDescriptionKey: "Backend server is down"
      ])
    }
    
    guard httpResponse.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }
    
    let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
    return authResponse.result
  }
}



