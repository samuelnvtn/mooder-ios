//
//  SettingsScreenViewModel.swift
//  Mooder
//
//  Created by Fietstopa on 22.06.2025.
//
import Foundation
import SwiftUI
import FirebaseAuth
import PhotosUI
import CoreData

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var userEmail: String = ""
    @Published var userName: String = ""
    @Published var selectedImage: UIImage?

    init() {
        loadUser()
        loadSavedProfileImage()

    }

    func loadUser() {
        if let user = Auth.auth().currentUser {
            userEmail = user.email ?? "unknown"
            userName = user.displayName ?? "Test User"
        }
    }

    
    
    func saveProfileImageToCoreData(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.9),
              let userID = Auth.auth().currentUser?.uid else { return }

        let context = CoreDataManager.shared.context

        // Najdi nebo vytvoř profil
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        request.predicate = NSPredicate(format: "userID == %@", userID)

        let profile = (try? context.fetch(request).first) ?? UserProfile(context: context)
        profile.userID = userID
        profile.profilePic = data

        do {
            try context.save()
            print("✅ Profile image saved")
        } catch {
            print("❌ Failed to save image: \(error)")
        }
    }

    func loadSavedProfileImage() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        request.predicate = NSPredicate(format: "userID == %@", userID)

        if let profile = try? CoreDataManager.shared.context.fetch(request).first,
           let data = profile.profilePic,
           let image = UIImage(data: data) {
            self.selectedImage = image
        }
    }

}

