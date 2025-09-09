//
//  Models.swift
//  StartupsTest
//
//  Created by Сергей on 07.09.2025.
//
struct JSONRPCRequest: Codable {
  var jsonrpc = "2.0"
  let method: String
  let params: [String: String]
  var id = 1
}

struct AuthResponse: Codable {
  let result: AuthResult
}

struct AuthResult: Codable {
  let accessToken: String
  let me: User
}

struct User: Codable {
  let id: Int
  let name: String
}

