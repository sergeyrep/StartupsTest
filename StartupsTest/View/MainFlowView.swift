//
//  InitialView.swift
//  StartupsTest
//
//  Created by Сергей on 11.09.2025.
//

import SwiftUI

enum AppFlowRoute: Hashable {
  case main
  case auth
}

struct MainFlowView: View {
  
  @State private var path = NavigationPath()
  //@State private var route: [AppFlowRoute] = [.auth, .main]
  @State private var isAuthenticated: Bool = false
  
  init() {
    // Создаем путь с начальными значениями
    var path = NavigationPath()
    path.append(AppFlowRoute.auth)
    if KeychainService().getAccessToken() != nil {
      path.append(AppFlowRoute.main)
    }   
    _path = State(initialValue: path)
  }
  
  var body: some View {
    NavigationStack(path: $path) {
      ProgressView()
        .onAppear {
          checkAuthentication()
        }
        .navigationDestination(for: AppFlowRoute.self) { route in
          switch route {
          case .main:
            MainView(viewModel: .init())
          case .auth:
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
  
  private func checkAuthentication() {
    let hasToken = KeychainService().getAccessToken() != nil
    isAuthenticated = hasToken
  }
}



