//
//  KeychainService.swift
//  StartupsTest
//
//  Created by Сергей on 07.09.2025.
//

import Foundation
import Security

class KeychainService {
  static let shared = KeychainService()
  private let service = "com.Res.StartupsTest"
  
  func saveAccessToken(_ token: String) {
    guard let data = token.data(using: .utf8) else { return }
    
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: "accessToken",
      kSecValueData as String: data
    ]
    
    SecItemDelete(query as CFDictionary)
    SecItemAdd(query as CFDictionary, nil)
  }
  
  func getAccessToken() -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: "accessToken",
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    var result: AnyObject?
    SecItemCopyMatching(query as CFDictionary, &result)
    
    guard let data = result as? Data else { return nil }
    return String(data: data, encoding: .utf8)
  }
  
  func deleteAccessToken() {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: "accessToken"
    ]
    
    SecItemDelete(query as CFDictionary)
  }
}

