//
//  LearningSessionView.swift
//  vocabflow
//
//  Created by Kevin Sofyan on 24/01/26.
//

import SwiftUI

struct LearningSessionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var sessionLists: [SessionWordList] = [
        SessionWordList(name: "Animals & Nature", wordCount: 12, type: .new),
        SessionWordList(name: "Science Terms", wordCount: 8, type: .review),
        SessionWordList(name: "Everyday Words", wordCount: 15, type: .new),
        SessionWordList(name: "Advanced Vocabulary", wordCount: 10, type: .review),
        SessionWordList(name: "School Words", wordCount: 6, type: .new)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header subtitle
                Text("Ready to learn? Here are your word lists for today!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                
                // Word Lists
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(sessionLists) { list in
                            SessionListCard(list: list) {
                                // Shuffle action - move to end of list
                                if let index = sessionLists.firstIndex(where: { $0.id == list.id }) {
                                    let removed = sessionLists.remove(at: index)
                                    sessionLists.append(removed)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
                
                // Start Session Button
                VStack(spacing: 0) {
                    Button(action: {
                        // Start the learning session
                    }) {
                        Text("Start Session")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.accentPurple)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 16)
                }
                .background(Color(UIColor.systemBackground))
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Today's Words")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

// MARK: - Session Word List Model
struct SessionWordList: Identifiable {
    let id = UUID()
    let name: String
    let wordCount: Int
    let type: SessionListType
}

enum SessionListType {
    case new
    case review
    
    var label: String {
        switch self {
        case .new: return "New"
        case .review: return "Review"
        }
    }
    
    var color: Color {
        switch self {
        case .new: return .cyan
        case .review: return .accentPurple
        }
    }
}

// MARK: - Session List Card
struct SessionListCard: View {
    let list: SessionWordList
    var onShuffle: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(list.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(list.type.label)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(list.type.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(list.type.color.opacity(0.15))
                        .cornerRadius(4)
                }
                
                Text("\(list.wordCount) words")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onShuffle) {
                Image(systemName: "shuffle")
                    .foregroundColor(.gray)
                    .font(.body)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    LearningSessionView()
}
