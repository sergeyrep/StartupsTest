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
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
                
                Text("Загрузка...")
                    .foregroundColor(.white)
                    .fontWeight(.medium)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
            )
        }
    }
}
