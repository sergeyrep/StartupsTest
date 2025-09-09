//
//  AuthViewModel.swift
//  StartupsTest
//
//  Created by Сергей on 07.09.2025.
//
import Firebase
import SwiftUI

struct ContentView: View {
  
  @EnvironmentObject var authViewModel: AuthViewModel
  @StateObject var giftsVM: ViewModel
  
  var body: some View {
    Group {
      if authViewModel.isAuthenticated {
        MainView(viewModel: .init())
      } else {
        WelcomeView()
      }
    }
    .withViewState(
      isLoading: $authViewModel.isLoading,
      error: $authViewModel.error
    )
    .onAppear {
      authViewModel.checkAuthenticationStatus()
      configureTabBar()
    }
  }
  
  private func configureTabBar() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .white
    
    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
  }
}

#Preview {
  ContentView(giftsVM: .init())
}

extension View {
  func withViewState(isLoading: Binding<Bool>, error: Binding<String?>) -> some View {
    self.modifier(ViewStateModifier(isLoading: isLoading, error: error))
  }
}



