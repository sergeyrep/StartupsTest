////
////  AuthStateService.swift
////  StartupsTest
////
////  Created by Сергей on 11.09.2025.
////
//
//import Foundation
//
//@MainActor
//final class AuthStateService: ObservableObject {
//  
//  @Published var isAuthenticated = false
//  static let shared = AuthStateService()
//  
//  private init() {
//    if KeychainService.shared.getAccessToken() != nil {
//      isAuthenticated = true
//    }
//  }
//  
//  func login() {
//    isAuthenticated = true
//  }
//  
//  func logout() {
//    isAuthenticated = false
//  }
//}
