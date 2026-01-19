//
//  CreateAccountView.swift
//  vocabflow
//
//  Created by Kevin Sofyan on 19/01/26.
//

import SwiftUI

struct CreateAccountView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Logo
                    LogoView()
                        .padding(.top, 20)
                    
                    // Title
                    Text("Join VocabFlow AI")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    
                    // Form Fields
                    VStack(spacing: 16) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline)
                                .foregroundColor(.primary)

                            HStack(spacing: 12) {
                                Image(systemName: "envelope")
                                    .foregroundColor(.gray)
                                    .frame(width: 20)

                                TextField("your.email@example.com", text: $email)
                                    .textContentType(.emailAddress)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        }

                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .foregroundColor(.primary)

                            HStack(spacing: 12) {
                                Image(systemName: "lock")
                                    .foregroundColor(.gray)
                                    .frame(width: 20)

                                if isPasswordVisible {
                                    TextField("Password", text: $password)
                                } else {
                                    SecureField("••••••••", text: $password)
                                }

                                Button(action: { isPasswordVisible.toggle() }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Plan Info
                    VStack(spacing: 4) {
                        Text("Start free plan (1 child)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            // Handle upgrade action
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "link")
                                    .font(.caption)
                                Text("Upgrade plan to add more children")
                                    .font(.subheadline)
                            }
                            .foregroundColor(Color.accentPurple)
                        }
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Create Account Button
                    NavigationLink(destination: AddChildProfileView()) {
                        Text("Create account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.accentPurple)
                            .cornerRadius(28)
                    }
                    .padding(.horizontal)
                    
                    // Sign In Link
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundColor(.secondary)
                        Button(action: {
                            // Handle sign in action
                        }) {
                            Text("Sign in")
                                .foregroundColor(Color.accentPurple)
                                .fontWeight(.medium)
                        }
                    }
                    .font(.subheadline)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Logo View
struct LogoView: View {
    var body: some View {
        ZStack {
            // Graduation cap icon
            Image(systemName: "graduationcap")
                .font(.system(size: 50))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.accentPurple, Color.accentPurple.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .frame(width: 80, height: 80)
    }
}

// MARK: - Custom Colors
extension Color {
    static let accentPurple = Color(red: 0.45, green: 0.40, blue: 0.85)
    static let accentGreen = Color(red: 0.25, green: 0.75, blue: 0.55)
}

#Preview {
    CreateAccountView()
}
