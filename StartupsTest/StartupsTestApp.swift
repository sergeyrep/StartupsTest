//
//  StartupsTestApp.swift
//  StartupsTest
//
//  Created by Сергей on 07.09.2025.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct YourApp: App {
  
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject private var authViewModel = AuthViewModel()
  
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView(giftsVM: .init())
          .environmentObject(AuthViewModel())
      }
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
  
  func application(_ app: UIApplication,
                   open url: URL,
                   options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    return GIDSignIn.sharedInstance.handle(url)
  }
}
