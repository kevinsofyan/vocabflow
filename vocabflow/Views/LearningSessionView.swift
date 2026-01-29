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
    
    @State private var selectedListId: UUID?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header subtitle
                Text("Choose a word list to practice")
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
                            SessionListCard(
                                list: list,
                                isSelected: selectedListId == list.id,
                                onSelect: {
                                    selectedListId = list.id
                                },
                                onShuffle: {
                                    // Shuffle action - move to end of list
                                    if let index = sessionLists.firstIndex(where: { $0.id == list.id }) {
                                        let removed = sessionLists.remove(at: index)
                                        sessionLists.append(removed)
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
                
                // Start Session Button
                VStack(spacing: 0) {
                    NavigationLink(
                        destination: selectedListId != nil ? 
                            AnyView(StorySessionView(
                                wordList: sessionLists.first(where: { $0.id == selectedListId })!,
                                words: getWordsForList(sessionLists.first(where: { $0.id == selectedListId })!)
                            )) : AnyView(EmptyView())
                    ) {
                        Text("Start Session")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(selectedListId != nil ? Color.accentPurple : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(selectedListId == nil)
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
    
    private func getWordsForList(_ list: SessionWordList) -> [String] {
        // Sample words for each list - in production, this would fetch from the actual word list
        switch list.name {
        case "Animals & Nature":
            return ["ancient", "winding", "enchanting", "majestic", "wonder", "shimmering", "rustling", "gentle", "exploring", "trusty", "rumored", "dappled"]
        case "Science Terms":
            return ["molecule", "experiment", "gravity", "velocity", "hypothesis", "electron", "reaction", "laboratory"]
        case "Everyday Words":
            return ["beautiful", "exciting", "comfortable", "delicious", "adventure", "mysterious", "wonderful", "peaceful", "curious", "fantastic", "brilliant", "amazing", "incredible", "spectacular", "magnificent"]
        case "Advanced Vocabulary":
            return ["ephemeral", "serendipity", "ubiquitous", "enigmatic", "profound", "luminous", "ethereal", "melancholy", "resilient", "eloquent"]
        case "School Words":
            return ["classroom", "homework", "teacher", "student", "library", "notebook"]
        default:
            return ["word", "learn", "practice", "study", "read"]
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
    let isSelected: Bool
    var onSelect: () -> Void
    var onShuffle: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
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
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentPurple)
                        .font(.title2)
                }
                
                Button(action: onShuffle) {
                    Image(systemName: "shuffle")
                        .foregroundColor(.gray)
                        .font(.body)
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentPurple : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LearningSessionView()
}
