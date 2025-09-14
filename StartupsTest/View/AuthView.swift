//
//  WellcomeView.swift
//  StartupsTest
//
//  Created by Сергей on 07.09.2025.
//

import SwiftUI
import AuthenticationServices
import GoogleSignIn

struct AuthView: View {
  
  @StateObject var viewModel: ViewModel
  
  var body: some View {
    contentView
      .navigationDestination(isPresented: $viewModel.isAuth) {
        MainView(viewModel: .init())
      }
      .withViewState(
        isLoading: $viewModel.isLoading,
        error: $viewModel.error
      )
      .navigationBarBackButtonHidden(true)
  }
  
  private var contentView: some View {
    VStack(spacing: 0) {
      navBarView
      titleView
      backgoundImageView
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .overlay(foregroundView, alignment: .bottom)
    .background(.veryLight)
  }
  
  private var backgoundImageView: some View {
    Image(ImageSet.Vector)
  }
  
  private var foregroundView: some View {
    VStack(spacing: 9) {
      Image(ImageSet.image8)
      buttonsView
    }
    .padding(.bottom, 104)
  }
  
  private var buttonsView: some View {
    VStack(spacing: 8) {
      AppleSignInButton { viewModel.signIn(type: .apple) }
      GoogleSignInButton { viewModel.signIn(type: .google) }
      
      Text(viewModel.policyText)
        .font(.system(size: 11))
    }
  }
  
  private var titleView: some View {
    VStack(alignment: .leading) {
      Text("WELCOME")
        .font(.system(size: 64, weight: .bold, design: .none))
      Text(viewModel.subTitleText)
        .font(.system(size: 14))
        .foregroundColor(.lightGray)
        .lineLimit(2)
        .fixedSize(horizontal: false, vertical: true)
    }
    .frame(maxWidth: .infinity, alignment: .top)
  }
  
  private var navBarView: some View {
    HStack {
      Spacer()
      Button("Skip", action: {})
        .padding(.top, 11)
        .padding(.trailing, 11)
        .foregroundColor(.black)
    }
    .frame(height: 44)
  }
}

extension View {
  func withViewState(isLoading: Binding<Bool>, error: Binding<String?>) -> some View {
    self.modifier(ViewStateModifier(isLoading: isLoading, error: error))
  }
}

//
//#Preview {
//  AuthView(viewModel: .init())
//}
