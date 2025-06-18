//
//  AuthViewModel.swift
//  Mooder
//
//  Created by Samuel Novotný on 18.06.2025.
//

import Foundation
import SwiftUI
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class AuthViewModel: ObservableObject {
    @Published var isLoginMode = true
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""

    func handleAction() {
        if isLoginMode {
            print("Logging in with \(email), \(password)")
            // Později: Firebase login
        } else {
            print("Registering \(username), \(email), \(password)")
            // Později: Firebase register
        }
    }

    func toggleMode(toLogin: Bool) {
        isLoginMode = toLogin
    }
    
    func signInWithGoogle() {
        print("🔍 Google sign-in tapped")

        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("❌ Missing client ID")
            return
        }

        let config = GIDConfiguration(clientID: clientID)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("❌ Could not find root view controller")
            return
        }

        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("❌ Google sign-in error: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("❌ Missing ID token")
                return
            }

            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("❌ Firebase auth error: \(error.localizedDescription)")
                } else {
                    print("✅ Logged in with Google")
                }
            }
        }
    }
}
