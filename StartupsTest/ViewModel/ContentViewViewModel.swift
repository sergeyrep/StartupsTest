//
//  File.swift
//  StartupsTest
//
//  Created by Сергей on 09.09.2025.
//

import Foundation

extension ContentView {
  
  final class ViewModel: ObservableObject {
    
    @Published var gifts: TabBarItem = .gifts
  }
}
