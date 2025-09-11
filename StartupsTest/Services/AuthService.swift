//
//  FirebaseService.swift
//  StartupsTest
//
//  Created by Сергей on 10.09.2025.
//

import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

enum AuthError: Error {
  case cancelled
  case unknown
  case logOutFailed
  case invalidToken
}

enum AuthType: String {
  case google
  case apple
}

protocol AuthServiceProtocol {
  func signIn(type: AuthType) async throws -> String
  func logOut() async throws
}

final class AuthService: AuthServiceProtocol {
  
  func logOut() async throws {
    guard let rawType = UserDefaults.standard.string(forKey: Constants.Keys.authTypeKey),
          let type = AuthType(rawValue: rawType) else { throw AuthError.unknown }
    switch type {
    case .apple: try await logOutGoogle()
    case .google: try await logOutGoogle()
    }
  }
  
  func signIn(type: AuthType) async throws -> String {
    switch type {
    case .google: try await signInWithGoogle()
    case .apple: try await signInWithApple()
    }
  }
  
  @MainActor
  private func signInWithGoogle() async throws -> String {
    
    guard let clientID = FirebaseApp.app()?.options.clientID else { throw AuthError.unknown }
    
    guard let windowScene = /*await*/ UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootViewController = /*await*/ windowScene.windows.first?.rootViewController else {
      throw AuthError.unknown
    }
    
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config
    
    return try await withCheckedThrowingContinuation { continuation in
      GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
        
        if let error = error {
          continuation.resume(throwing: error)
          return
        }
        //user.authentication.idToken
        guard let user = result?.user,
              let idToken = user.idToken?.tokenString else {
          continuation.resume(throwing: AuthError.unknown)
          return
        }
        
        let accessToken = user.accessToken.tokenString
        let credential = GoogleAuthProvider.credential(
          withIDToken: idToken,
          accessToken: accessToken
        )
        
        Task {
          do {
            let result = try await Auth.auth().signIn(with: credential)
            let idToken = try await result.user.getIDToken()
            continuation.resume(returning: idToken)
          } catch {
            continuation.resume(throwing: error)
          }
        }
      }
    }
  }
  
  private func signInWithApple() async throws -> String {
    throw AuthError.unknown // TODO: Реализовать Apple Sign-In
  }
  
  private func logOutGoogle() async throws {
    try Auth.auth().signOut()
    GIDSignIn.sharedInstance.signOut()
    
    UserDefaults.standard.removeObject(forKey: Constants.Keys.userKey)
    UserDefaults.standard.removeObject(forKey: Constants.Keys.userIdKey)
    UserDefaults.standard.removeObject(forKey: Constants.Keys.authTypeKey)
  }
}
