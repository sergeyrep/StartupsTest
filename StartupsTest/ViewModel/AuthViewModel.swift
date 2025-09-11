//
//  AuthViewModel.swift
//  StartupsTest
//
//  Created by Сергей on 07.09.2025.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import SwiftUI
import FirebaseCore
import CryptoKit

extension AuthView {
  
  @MainActor
  final class ViewModel: NSObject, ObservableObject {
    
    @Published var isLoading = false
    @Published var error: String?
    @Published var isAuth = false
    
    private let networkService: NetworkServiceProtocol
    private let keychainService: KeychainService
    private let authService: AuthServiceProtocol
   
    let policyText: String = "By continuing, you agree to Assetsy’s Terms of Use and Privacy Policy."
    let subTitleText: String = "Enter your phone number. We will send you an SMS with a confirmation code to this number."
    
    init(
      networkService: NetworkServiceProtocol,
      keychainService: KeychainService,
      authService: AuthServiceProtocol
    ) {
      self.networkService = networkService
      self.keychainService = keychainService
      self.authService = authService
      super.init()
      //login()
    }
    
    //  func login() {
    //    if keychainService.getAccessToken() != nil {
    //      let userId = UserDefaults.standard.integer(forKey: "userId")
    //      if let userName = UserDefaults.standard.string(forKey: "userName"), userId != 0 {
    //        user = User(id: userId, name: userName)
    //        isAuthenticated = true
    //      }
    //    }
    //  }
    
    func signIn(type: AuthType) {
      isLoading = true
      error = nil
      
      Task {
        do {
          let idToken = try await authService.signIn(type: type)
          try await sendToken(idToken: idToken, authType: type)
        } catch {
          await MainActor.run {
            self.handleError(error.localizedDescription)
          }
        }
      }
    }
    
    private func saveAuthInfo(/*_ authResult: AuthResult,*/ authType: AuthType) async throws {
      //keychainService.saveAccessToken(authResult.accessToken)
      //UserDefaults.standard.set(authResult.me.id, forKey: Constants.Keys.userKey)
      //UserDefaults.standard.set(authResult.me.name, forKey: Constants.Keys.userIdKey)//readme!!!
      UserDefaults.standard.set(authType.rawValue, forKey: Constants.Keys.authTypeKey)
    }
    
    private func sendToken(idToken: String, authType: AuthType) async throws {
      do {
        //let authResult = try await networkService.sendIdTokenToBackend(idToken)
        try await saveAuthInfo(authType: authType)
        
        await MainActor.run {
          self.isLoading = false
          self.isAuth = true
        }
      } catch {
          handleError(error.localizedDescription)
      }
    }
    
    private func handleError(_ message: String) {
      error = message
      isLoading = false
      print("❌ Error: \(message)")
    }
  }
}

