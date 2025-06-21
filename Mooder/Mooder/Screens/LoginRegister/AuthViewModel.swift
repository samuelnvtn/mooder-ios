import Foundation
import SwiftUI
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @AppStorage("rememberMe") var rememberMe: Bool = false
    @AppStorage("isUserPersisted") var isUserPersisted: Bool = false
    
    @Published var isLoginMode = true
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoggedIn = false
    @Published var rememberMeChecked = false
    @Published var moodsDidSync = false

    private let coreDataManager = CoreDataManager() // reusujeme ho

    init() {
        print("🔁 AuthViewModel INIT \(UUID().uuidString)")
        if isUserPersisted {
            self.isLoggedIn = true
        }
    }

    func handleAction() {
        if isLoginMode {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("❌ Login failed: \(error.localizedDescription)")
                } else {
                    if self.rememberMe {
                        self.isUserPersisted = true
                    }
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                        self.syncFromFirestore()
                    }
                    print("✅ Logged in as \(result?.user.uid ?? "unknown")")
                }
            }
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error as NSError? {
                    switch AuthErrorCode(rawValue: error.code) {
                    case .emailAlreadyInUse:
                        self.errorMessage = "This email is already in use."
                    case .invalidEmail:
                        self.errorMessage = "Invalid email address."
                    case .weakPassword:
                        self.errorMessage = "Password must be at least 6 characters."
                    default:
                        self.errorMessage = error.localizedDescription
                    }
                    print("❌ Registration failed: \(error.localizedDescription)")
                    return
                }

                guard let uid = result?.user.uid else {
                    print("❌ UID is nil")
                    return
                }
                print("✅ Registration success, UID: \(uid)")

                let userData = [
                    "username": self.username,
                    "email": self.email
                ]

                Firestore.firestore().collection("users").document(uid).setData(userData) { error in
                    if let error = error {
                        print("❌ Failed to save user data: \(error.localizedDescription)")
                    } else {
                        print("✅ User data saved to Firestore")
                        if self.rememberMe {
                            self.isUserPersisted = true
                        }
                        DispatchQueue.main.async {
                            self.isLoginMode = true
                            self.isLoggedIn = true
                            self.syncFromFirestore()
                        }
                    }
                }
            }
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
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                        self.syncFromFirestore()
                    }
                    print("✅ Logged in with Google")
                }
            }
        }
    }
    
    
    private func syncFromFirestore() {
        print("🔄 Starting sync from Firestore...")
        let syncManager = FirestoreSyncManager()

        coreDataManager.clearAllMoods()

        syncManager.fetchMoods { moods in
            DispatchQueue.main.async {
                print("📥 Downloaded \(moods.count) moods from Firestore")
                for mood in moods {
                    self.coreDataManager.saveSyncedMood(from: mood)
                }
                print("✅ All moods saved to CoreData")
                
                // 💥 TADY, až teď to můžeš pustit
                self.moodsDidSync = true
            }
        }
    }


}
