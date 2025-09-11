//
//  File.swift
//  StartupsTest
//
//  Created by Сергей on 09.09.2025.
//
import SwiftUI

struct LoadingView: View {
  var body: some View {
    ZStack {
      Color.veryLight
        .ignoresSafeArea()
      
      VStack(spacing: 16) {
        ProgressView()
          .scaleEffect(1.5)
          .tint(.lightGray)
        
        Text("Загрузка...")
          .foregroundColor(.lightGray)
          .fontWeight(.medium)
      }
      .padding(24)
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(Color(.prelight))
      )
    }
  }
}

#Preview {
  LoadingView()
}
