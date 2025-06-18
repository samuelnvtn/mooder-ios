//
//  LoginRegisterView.swift
//  Mooder
//
//  Created by Samuel Novotný on 18.06.2025.
//

import SwiftUI

struct LoginRegisterView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.colorScheme) var colorScheme


    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: colorScheme == .dark ? "face.smiling.inverse" : "face.smiling")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)

            Text("Mooder")
                .font(.largeTitle)
                .bold()

            HStack {
                Button("Sign up") {
                    viewModel.toggleMode(toLogin: true)
                }
                .padding()
                .background(viewModel.isLoginMode ? Color.gray.opacity(0.2) : Color.clear)
                .cornerRadius(8)

                Button("Register") {
                    viewModel.toggleMode(toLogin: false)
                }
                .padding()
                .background(!viewModel.isLoginMode ? Color.gray.opacity(0.2) : Color.clear)
                .cornerRadius(8)
            }

            if !viewModel.isLoginMode {
                TextField("Your username", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            TextField("Your email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Error message block
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Button(viewModel.isLoginMode ? "Sign in" : "Register") {
                viewModel.handleAction()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.black)
            .foregroundColor(.white)
            .cornerRadius(8)

            Text(viewModel.isLoginMode ? "Other sign in options" : "Other registration options")
                .foregroundColor(.gray)
                .font(.footnote)

            Button(action: {
                viewModel.signInWithGoogle()
            }) {
                HStack {
                    Image(systemName: "g.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Continue with Google")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }

            Spacer()
        }
        .padding()
    }
}
