//
//  InitialViewModel.swift
//  StartupsTest
//
//  Created by Сергей on 12.09.2025.
//

//import Foundation
//
//extension InitialView {
//  
//  final class ViewModel: ObservableObject {
//    
//    private let keychainService: KeychainService
//    
//    init(keychainService: KeychainService) {
//      self.keychainService = keychainService
//      login()
//    }
//    
//    func login() {
//      if keychainService.getAccessToken() != nil {
//        let userId = UserDefaults.standard.integer(forKey: "userId")
//        if let userName = UserDefaults.standard.string(forKey: "userName"), userId != 0 {
//          user = User(id: userId, name: userName)
//          isAuth = true
//        }
//      }
//    }
//  }
//}
