//
//  GiftsView.swift
//  StartupsTest
//
//  Created by Сергей on 07.09.2025.
//

import Foundation
import SwiftUI
import Combine

struct MainView: View {
  
  @StateObject var viewModel: ViewModel
  
  var body: some View {
    TabView(selection: $viewModel.selectedTab) {
      ForEach(TabBarItem.allCases, id: \.self) { tab in
        NavigationStack {
          makeTabView(tab)
        }
        .tabItem {
          Image(tab.image)
        }
        .tag(tab.title)
      }
    }
  }
  
  @ViewBuilder
  private func makeTabView(_ tab: TabBarItem) -> some View {
    switch tab {
    case .gifts:
      GiftsView(viewModel: .init(gift: .init()))
    case .gift:
      Text("Gifts")
    case .events:
      Text("Events")
    case .cart:
      Text("Cart")
    case .profile:
      Text("Profile")
    }
  }
}

extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
}

#Preview {
  GiftsView(viewModel: .init(gift: .init()))
    .environmentObject(AuthViewModel())
}




