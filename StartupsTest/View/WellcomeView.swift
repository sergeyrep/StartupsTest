//
//  WellcomeView.swift
//  StartupsTest
//
//  Created by Сергей on 07.09.2025.
//

import SwiftUI
import AuthenticationServices
import GoogleSignIn

struct WelcomeView: View {
  
  @EnvironmentObject var authViewModel: AuthViewModel

  var body: some View {
    ZStack {
      Color.veryLight
        .ignoresSafeArea(.all)

      VStack(spacing: 0) {
        NavBar
        Title

        ZStack {
          Image(ImageSet.Vector)
          Image(ImageSet.image8)
            .offset(y: -60)

          VStack(spacing: 8) {
            Spacer()
            
            AppleSignInButton(action: authViewModel.signInWithApple)
            GoogleSignInButton(action: authViewModel.signInWithGoogle)

            Text("By continuing, you agree to Assetsy’s Terms of Use and Privacy Policy.")
              .font(.system(size: 11))
          }
          .padding(.bottom, 20)
        }
        .padding(.bottom, 50)
      }
    }
  }

  private var Title: some View {
    VStack(alignment: .leading) {
      Text("WELCOME")
        .font(.system(size: 64, weight: .bold, design: .none))
      Text("Enter your phone number. We will send you an SMS with a confirmation code to this number.")
        .font(.system(size: 14))
        .foregroundColor(.lightGray)
        .fixedSize(horizontal: false, vertical: true)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  }

  private var NavBar: some View {
    VStack {
      HStack {
        Spacer()
        Button("Skip", action: {})
          .padding(.top, 11)
          .padding(.trailing, 11)
          .foregroundColor(.black)
      }
      .frame(height: 44)
      Spacer()
    }
  }
}

#Preview {
  WelcomeView()
    .environmentObject(AuthViewModel())
}
