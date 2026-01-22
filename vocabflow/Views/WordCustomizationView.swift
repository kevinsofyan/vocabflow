//
//  WordCustomizationView.swift
//  vocabflow
//
//  Created by Kevin Sofyan on 22/01/26.
//

import SwiftUI

struct WordCustomizationView: View {
    @State private var words: [CustomizableWord] = [
        CustomizableWord(name: "Serendipity", spellingPriority: false, meaningPriority: false),
        CustomizableWord(name: "Ephemeral", spellingPriority: false, meaningPriority: false),
        CustomizableWord(name: "Ubiquitous", spellingPriority: true, meaningPriority: false),
        CustomizableWord(name: "Mellifluous", spellingPriority: false, meaningPriority: false),
        CustomizableWord(name: "Nefarious", spellingPriority: false, meaningPriority: false),
        CustomizableWord(name: "Rambunctious", spellingPriority: true, meaningPriority: false),
        CustomizableWord(name: "Capricious", spellingPriority: false, meaningPriority: false),
        CustomizableWord(name: "Equanimity", spellingPriority: true, meaningPriority: true),
        CustomizableWord(name: "Luminous", spellingPriority: false, meaningPriority: false)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Info Text
                    Text("Priority words appear in every learning session until mastered. You can mark up to 3 words as priority.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.top, 16)
                    
                    // Word List
                    VStack(spacing: 0) {
                        ForEach($words) { $word in
                            WordCustomizationRow(word: $word)
                            
                            if word.id != words.last?.id {
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
            
            // Skip for now button (sticky)
            VStack(spacing: 0) {
                Divider()
                
                NavigationLink(destination: OnboardingCompleteView()) {
                    Text("Skip for now")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .background(Color(UIColor.systemBackground))
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Customize Words")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
    }
}

// MARK: - Customizable Word Model
struct CustomizableWord: Identifiable {
    let id = UUID()
    let name: String
    var spellingPriority: Bool
    var meaningPriority: Bool
}

// MARK: - Word Customization Row
struct WordCustomizationRow: View {
    @Binding var word: CustomizableWord
    @State private var isFavorite: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Word name
            Text(word.name)
                .font(.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Spelling checkbox
            HStack(spacing: 6) {
                Button(action: { word.spellingPriority.toggle() }) {
                    Image(systemName: word.spellingPriority ? "circle.fill" : "circle")
                        .foregroundColor(word.spellingPriority ? .red : .gray)
                        .font(.system(size: 16))
                }
                Text("Spelling")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Meaning checkbox
            HStack(spacing: 6) {
                Button(action: { word.meaningPriority.toggle() }) {
                    Image(systemName: word.meaningPriority ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(word.meaningPriority ? .green : .gray)
                        .font(.system(size: 16))
                }
                Text("Meaning")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Star button
            Button(action: { isFavorite.toggle() }) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(isFavorite ? .yellow : .gray)
                    .font(.system(size: 18))
            }
            
            // More options button
            Button(action: {}) {
                Image(systemName: "info.circle")
                    .foregroundColor(.accentPurple)
                    .font(.system(size: 18))
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        WordCustomizationView()
    }
}
