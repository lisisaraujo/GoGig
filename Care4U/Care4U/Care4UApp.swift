//
//  Care4UApp.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI
import SwiftData
import FirebaseAuth
import FirebaseCore
import GooglePlaces

@main
struct Care4UApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate     // initializing google place api
    @StateObject var authViewModel = AuthViewModel()
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()

    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
            
        }
    }
}
