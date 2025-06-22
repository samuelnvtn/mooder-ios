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
    
    let helpURL = URL(string: "https://www.helpguide.org/find-help")!

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {
            
            Text("Settings")
                .font(.title)
                .bold()

            // Avatar + Email
            VStack {
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
                .frame(maxWidth: .infinity)
            }

            // Settings List
           
                Form {
                    Section(header: Text("Settings:")) {
                        NavigationLink("Legal", destination: Text("Legal Placeholder"))
                        Toggle("Daily Mood Reminder", isOn: $viewModel.notificationsEnabled)
                            .onChange(of: viewModel.notificationsEnabled) { enabled in
                                if enabled {
                                    NotificationManager.shared.scheduleDailyMoodReminder()
                                } else {
                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyMoodReminder"])
                                }
                            }
                        Button("Get Help") {
                            UIApplication.shared.open(helpURL)
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
            

            

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
            }
            .padding(.bottom, 16)
        }
        .padding()
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
    }
}
