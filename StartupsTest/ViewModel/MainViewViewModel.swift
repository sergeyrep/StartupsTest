//
//  1.swift
//  StartupsTest
//
//  Created by Сергей on 09.09.2025.
//

import Foundation

extension MainView {
  
  final class ViewModel: ObservableObject {
    
    @Published var selectedTab: TabBarItem = .gifts
  }
}

