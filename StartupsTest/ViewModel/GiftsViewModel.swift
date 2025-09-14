//
//  GiftsViewModel.swift
//  StartupsTest
//
//  Created by Сергей on 08.09.2025.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

extension GiftsView {
  
  @MainActor
  final class ViewModel: ObservableObject {
    
    @Published var gifts: [ImageSetData] = ImageSetData.mock
    @Published var collection: [Collection] = Collection.mock
    @Published var searchText: String = ""
    
    private let keychainService: KeychainService
    private let authService: AuthService
    
    init(
      gift: [ImageSetData],
      keychainService: KeychainService,
      authService: AuthService
    ) {
      self.keychainService = keychainService
      self.authService = authService
      Task { await fetchData() }
    }
    
    func logOut() async {
      do {
        keychainService.deleteAccessToken()
        try await authService.logOut()
      } catch {
        print(error)
      }
    }
    
    private func fetchData() async {
      do {
        let downloadGifts = try await NetworkService.shared.dowloadDataConteiner()
        gifts = downloadGifts
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
