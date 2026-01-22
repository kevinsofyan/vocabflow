//
//  WelcomeView.swift
//  vocabflow
//
//  Created by Kevin Sofyan on 19/01/26.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero Image
                Image(systemName: "figure.and.child.holdinghands")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 140)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.accentPurple.opacity(0.6), Color.accentPurple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.top, 20)

                // Welcome Title
                VStack(spacing: 12) {
                    Text("Welcome to VocabFlow AI!")
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.center)

                    Text("Our unique AI-powered method helps children learn new vocabulary in three easy steps.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }

                // Features List
                VStack(spacing: 20) {
                    FeatureRow(
                        icon: "square.and.pencil",
                        iconColor: Color.accentPurple,
                        title: "Add words",
                        description: "Parents can easily add specific vocabulary words, or select from curated lists tailored to your child's needs."
                    )

                    FeatureRow(
                        icon: "sparkles",
                        iconColor: Color.accentPurple,
                        title: "AI creates stories",
                        description: "Our intelligent AI crafts personalised, engaging stories featuring the new words in context for natural learning."
                    )

                    FeatureRow(
                        icon: "checkmark.circle",
                        iconColor: Color.accentPurple,
                        title: "Child learns",
                        description: "Children explore interactive stories and practice words through adaptive quizzes, making learning fun and effective."
                    )
                }
                .padding(.horizontal)

                // Get Started Button
                NavigationLink(destination: AddChildProfileView(isOnboarding: true)) {
                    Text("Get started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.accentPurple)
                        .cornerRadius(28)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Welcome")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // Handle menu action
                }) {
                    Image(systemName: "square.grid.2x2")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon with background
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
            }

            // Text content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
