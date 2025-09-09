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

@MainActor
class AuthViewModel: NSObject, ObservableObject {
  
  @Published var isAuthenticated = false
  @Published var user: User?
  @Published var isLoading = false
  @Published var error: String?
  
  private let networkService = NetworkService.shared
  private let keychainService = KeychainService.shared
  private var currentNonce: String?
  private var retryAttempts = 0
  private let maxRetryAttempts = 3
  
  override init() {
    super.init()
    checkAuthenticationStatus()
  }
  
  func checkAuthenticationStatus() {
    if keychainService.getAccessToken() != nil {
      let userId = UserDefaults.standard.integer(forKey: "userId")
      if let userName = UserDefaults.standard.string(forKey: "userName"), userId != 0 {
        user = User(id: userId, name: userName)
        isAuthenticated = true
      }
    }
  }
  
  func signInWithGoogle() {
    isLoading = true
    error = nil
    
    let clientID = "846639715995-6f1detdlh1igmh0h9nk9qkcbd3jjn3fq.apps.googleusercontent.com"
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config
    
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootViewController = windowScene.windows.first?.rootViewController else {
      handleError("Could not get root view controller")
      return
    }
    
    GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
      guard let self = self else { return }
      
      if let error = error {
        self.handleError("Google Sign-In failed: \(error.localizedDescription)")
        return
      }
      
      guard let user = result?.user, let idToken = user.idToken?.tokenString else {
        self.handleError("Failed to get user data from Google")
        return
      }
      
      let accessToken = user.accessToken.tokenString
      let credential = GoogleAuthProvider.credential(
        withIDToken: idToken,
        accessToken: accessToken
      )
      
      self.authenticateWithFirebase(credential: credential)
    }
  }
  
  func signInWithApple() {
    isLoading = true
    error = nil
    
    let nonce = randomNonceString()
    currentNonce = nonce
    
    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = [.fullName, .email]
    request.nonce = sha256(nonce)
    
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
  }
  
  private func authenticateWithFirebase(credential: AuthCredential) {
    Task {
      do {
        let result = try await Auth.auth().signIn(with: credential)
        let idToken = try await result.user.getIDToken()
        await completeAuthenticationWithRetry(idToken: idToken)
      } catch {
        await MainActor.run {
          self.handleError("Firebase authentication failed: \(error.localizedDescription)")
        }
      }
    }
  }
  
  private func completeAuthenticationWithRetry(idToken: String) async {
    do {
      try await completeAuthentication(idToken: idToken)
    } catch {
      if (error as NSError).code == 521 && retryAttempts < maxRetryAttempts {
        retryAttempts += 1
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        await completeAuthenticationWithRetry(idToken: idToken)
      } else {
        await handleBackendFallback(idToken: idToken)
      }
    }
  }
  
  private func completeAuthentication(idToken: String) async throws {
    let authResult = try await networkService.sendIdTokenToBackend(idToken)
    
    keychainService.saveAccessToken(authResult.accessToken)
    UserDefaults.standard.set(authResult.me.id, forKey: "userId")
    UserDefaults.standard.set(authResult.me.name, forKey: "userName")
    
    await MainActor.run {
      self.user = authResult.me
      self.isAuthenticated = true
      self.isLoading = false
    }
  }
  
  private func handleBackendFallback(idToken: String) async {
    guard let currentUser = Auth.auth().currentUser else {
      await MainActor.run {
        self.handleError("No Firebase user found")
      }
      return
    }
    
    await MainActor.run {
      let localUser = User(
        id: Int.random(in: 1000...9999),
        name: currentUser.displayName ?? currentUser.email?.components(separatedBy: "@").first ?? "User"
      )
      
      keychainService.saveAccessToken(idToken)
      UserDefaults.standard.set(localUser.id, forKey: "userId")
      UserDefaults.standard.set(localUser.name, forKey: "userName")
      
      user = localUser
      isAuthenticated = true
      isLoading = false
    }
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
      GIDSignIn.sharedInstance.signOut()
      keychainService.deleteAccessToken()
      UserDefaults.standard.removeObject(forKey: "userId")
      UserDefaults.standard.removeObject(forKey: "userName")
      
      isAuthenticated = false
      user = nil
    } catch {
      handleError("Sign out failed: \(error.localizedDescription)")
    }
  }
  
  private func handleError(_ message: String) {
    error = message
    isLoading = false
    print("❌ Error: \(message)")
  }
  
  private func randomNonceString(length: Int = 32) -> String {
    let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
      var randoms = [UInt8](repeating: 0, count: 16)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randoms.count, &randoms)
      if errorCode != errSecSuccess { fatalError("Unable to generate nonce") }
      
      for random in randoms {
        if remainingLength == 0 { break }
        result.append(charset[Int(random) % charset.count])
        remainingLength -= 1
      }
    }
    return result
  }
  
  private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashed = SHA256.hash(data: inputData)
    return hashed.compactMap { String(format: "%02x", $0) }.joined()
  }
}

extension AuthViewModel: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
          let appleIDToken = appleIDCredential.identityToken,
          let idTokenString = String(data: appleIDToken, encoding: .utf8),
          let nonce = currentNonce else {
      handleError("Failed to get Apple credentials")
      return
    }
    
    let credential = OAuthProvider.appleCredential(
      withIDToken: idTokenString,
      rawNonce: nonce,
      fullName: appleIDCredential.fullName
    )
    
    currentNonce = nil
    authenticateWithFirebase(credential: credential)
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    handleError("Apple Sign-In failed: \(error.localizedDescription)")
    currentNonce = nil
  }
}

extension AuthViewModel: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow } ?? UIWindow()
  }
}

