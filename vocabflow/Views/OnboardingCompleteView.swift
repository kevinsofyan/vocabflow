//
//  OnboardingCompleteView.swift
//  vocabflow
//
//  Created by Kevin Sofyan on 22/01/26.
//

import SwiftUI

struct OnboardingCompleteView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Trophy illustration
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.yellow.opacity(0.3), Color.orange.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 180, height: 180)
                
                VStack(spacing: 8) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.yellow, Color.orange],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    Text("🎉")
                        .font(.system(size: 40))
                }
            }
            .padding(.bottom, 20)
            
            // Title
            Text("All Set!")
                .font(.system(size: 32, weight: .bold))
            
            // Description
            Text("Your first list is ready! You can edit this list and create more lists anytime from the dashboard.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            // Go to Dashboard Button
            NavigationLink(destination: DashboardView()) {
                Text("Go to Dashboard")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.accentPurple)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .background(Color(UIColor.systemBackground))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        OnboardingCompleteView()
    }
}
