//
//  SettingsView.swift
//  Mooder
//
//  Created by Fietstopa on 22.06.2025.
import SwiftUI
import PhotosUI
import FirebaseAuth

struct SettingsScreenView: View {
    @StateObject var viewModel = SettingsViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showPhotoPicker = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {

        VStack {
            // Header
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                Spacer()
                Text("Notifications")
                    .font(.headline)
                Spacer()
                Spacer()
            }
            .padding()

            // Avatar + Email
            VStack(spacing: 8) {
                Button(action: {
                    showPhotoPicker = true
                }) {
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        Image("john_pork") // fallback
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    }
                }
                .buttonStyle(.plain)

                Text(viewModel.userName)
                    .font(.title2)
                    .bold()

                Text(viewModel.userEmail)
                    .foregroundColor(.gray)
            }
            .padding(.top)

            // Settings List
            Form {
                Section(header: Text("Settings:")) {
                    NavigationLink("Legal", destination: Text("Legal Placeholder"))
                    NavigationLink("Notifications", destination: Text("Notifications Placeholder"))
                    NavigationLink("Get Help", destination: Text("Help Placeholder"))
                }
            }

            Spacer()

            // Sign Out
            Button(role: .destructive) {
                do {
                       try Auth.auth().signOut()
                       authViewModel.isLoggedIn = false // 💥 tohle dělá tu magii
                   } catch {
                       print("❌ Failed to sign out: \(error.localizedDescription)")
                   }
            } label: {
                Text("Sign Out")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
            }
            .padding(.bottom, 16)
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedItem)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    viewModel.selectedImage = uiImage
                    viewModel.saveProfileImageToCoreData(uiImage) // 💥 tohle jsi tam neměl!
                }
            }
        }

        .navigationBarHidden(true)
    }
}
