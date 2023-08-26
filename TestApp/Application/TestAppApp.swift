//
//  TestAppApp.swift
//  TestApp
//
//  Created by 추현호 on 2023/08/12.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    
    return true
  }
}

@main
struct TestAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var mainViewModel = MainViewModel()
    
    var body: some Scene {
        
        WindowGroup {
//            ContentView()
//            CarRegistrationView(mainViewModel: mainViewModel)
            MapView()
        }
    }
}
