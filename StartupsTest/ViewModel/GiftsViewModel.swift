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
  
  final class ViewModel: ObservableObject {
    
    @Published var gifts: [ImageSetData] = ImageSetData.mock
    @Published var collection: [Collection] = Collection.mock
    @Published var searchText: String = ""
    @Published var gift: [ImageSetData] = [] //добавил и все что ниже
//    @Published var isAuthenticated = false
//    @Published var user: User?
//    @Published var isLoading = false
//    @Published var error: String?
    
   // private let keychainService = KeychainService.shared
    
    init(gift: [ImageSetData]) {
      self.gift = gift
      Task { await fetchData() }
    }
    
    private func fetchData() async {
      do {
        let downloadGifts = try await NetworkService.shared.dowloadDataConteiner()
        gifts = downloadGifts
      } catch {
        print(error.localizedDescription)
      }
    }
    
//    func signOut() {
//      do {
//        try Auth.auth().signOut()
//        GIDSignIn.sharedInstance.signOut()
//        keychainService.deleteAccessToken()
//        UserDefaults.standard.removeObject(forKey: "userId")
//        UserDefaults.standard.removeObject(forKey: "userName")
//        
//        isAuthenticated = false
//        user = nil
//        objectWillChange.send()
//      } catch {
//        print("error signOut")
//      }
//    }
  }
}
