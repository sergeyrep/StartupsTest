//
//  InitialView.swift
//  StartupsTest
//
//  Created by Сергей on 11.09.2025.
//

import SwiftUI

struct InitialView: View {
  
  var body: some View {
    NavigationStack {
      if KeychainService.shared.getAccessToken() != nil {
        MainView(viewModel: .init())
      } else {
        AuthView(
          viewModel: .init(
            networkService: NetworkService.shared,
            keychainService: KeychainService(),
            authService: AuthService()
          )
        )
      }
    }
  }
}
