//
//  WordInputView.swift
//  vocabflow
//
//  Created by Kevin Sofyan on 21/01/26.
//

import SwiftUI

struct WordInputView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var listName: String = ""
    @State private var words: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Info Text
                Text("Sessions are 10-15 minutes; each session selects 5 words.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // Create Custom Word List Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Create Custom Word List")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // List Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("List Name")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("My New Words", text: $listName)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        // Words Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Words (comma-separated)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextEditor(text: $words)
                                .frame(height: 120)
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .overlay(
                                    Group {
                                        if words.isEmpty {
                                            Text("apple, banana, orange, grape, kiwi")
                                                .foregroundColor(.gray.opacity(0.5))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 16)
                                                .allowsHitTesting(false)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                        }
                                    }
                                )
                        }
                        
                        // Add Custom List Button
                        Button(action: {
                            // Handle add custom list
                        }) {
                            Text("Add Custom List")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.accentPurple)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Or Select a Curated Word Pack Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Or Select a Curated Word Pack")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            WordPackCard(
                                title: "Grade 2 Vocabulary",
                                description: "Essential words for 7-8 year olds.",
                                imageName: "book.fill",
                                backgroundColor: Color.red.opacity(0.2)
                            )
                            
                            WordPackCard(
                                title: "SAT Prep Words",
                                description: "High-frequency words for college entrance exams.",
                                imageName: "graduationcap.fill",
                                backgroundColor: Color.blue.opacity(0.2)
                            )
                            
                            WordPackCard(
                                title: "Science Terms",
                                description: "Common scientific vocabulary for kids.",
                                imageName: "flask.fill",
                                backgroundColor: Color.green.opacity(0.2)
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 8)
                
                Spacer()
                    .frame(height: 40)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Add Words")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
    }
}

// MARK: - Word Pack Card
struct WordPackCard: View {
    let title: String
    let description: String
    let imageName: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .frame(height: 140)
                
                Image(systemName: imageName)
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            
            // Title
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            // Description
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .frame(height: 36)
            
            // View Pack Button
            Button(action: {
                // Handle view pack
            }) {
                Text("View Pack")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.accentPurple)
            }
        }
        .frame(width: 200)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        WordInputView()
    }
}
