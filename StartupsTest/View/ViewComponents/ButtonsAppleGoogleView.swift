//
//  ButtonAppleGoogleView.swift
//  StartupsTest
//
//  Created by Сергей on 09.09.2025.
//

import SwiftUI

struct AppleSignInButton: View {
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack {
        Image(ImageSet.apple)
        Text("Continue with Apple")
          .foregroundColor(Color.black)
      }
      .frame(width: 362, height: 56)
      .background(Color.white)
      .cornerRadius(10)
    }
  }
}

struct GoogleSignInButton: View {
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack {
        Image(ImageSet.Other)
        Text("Continue with Google")
          .foregroundColor(Color.black)
      }
      .frame(width: 362, height: 56)
      .background(Color.white)
      .cornerRadius(10)
    }
  }
}
