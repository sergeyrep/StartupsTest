//
//  File1.swift
//  StartupsTest
//
//  Created by Сергей on 09.09.2025.
//

import SwiftUI

struct ViewStateModifier: ViewModifier {
  @Binding var isLoading: Bool
  @Binding var error: String?
  
  func body(content: Content) -> some View {
    content
      .overlay {
        if isLoading {
          LoadingView()
        }
      }
      .alert("Ошибка", isPresented: .constant(error != nil)) {
        Button("OK", role: .cancel) {
          error = nil
        }
      } message: {
        Text(error ?? "Неизвестная ошибка")
      }
  }
}
