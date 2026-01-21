//
//  WordListsView.swift
//  vocabflow
//
//  Created by Kevin Sofyan on 21/01/26.
//

import SwiftUI

struct WordListsView: View {
    @State private var selectedTab = 0
    
    let wordLists = [
        WordList(name: "Animals & Nature", wordCount: 25, progress: 0.75, struggling: 3, progressing: 7, mastered: 15),
        WordList(name: "Space Exploration", wordCount: 18, progress: 0.40, struggling: 8, progressing: 6, mastered: 4),
        WordList(name: "Daily Adventures", wordCount: 30, progress: 0.90, struggling: 1, progressing: 2, mastered: 27),
        WordList(name: "Mythical Creatures", wordCount: 12, progress: 0.60, struggling: 2, progressing: 4, mastered: 6)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Word Lists")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .padding(.top, 8)
                        
                        VStack(spacing: 12) {
                            ForEach(wordLists) { list in
                                NavigationLink(destination: ListDetailView(listName: list.name)) {
                                    WordListCard(list: list)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                            .frame(height: 20)
                        
                        // Create New List Button
                        NavigationLink(destination: WordInputView()) {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.headline)
                                Text("Create New List")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.accentPurple)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
                
                // Bottom Navigation
                HStack(spacing: 0) {
                    TabButton(icon: "list.bullet.clipboard", label: "Lists", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    
                    TabButton(icon: "chart.bar", label: "Progress", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                    
                    TabButton(icon: "person", label: "Profile", isSelected: selectedTab == 2) {
                        selectedTab = 2
                    }
                }
                .padding(.vertical, 8)
                .background(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "square.grid.2x2")
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

// MARK: - Word List Model
struct WordList: Identifiable {
    let id = UUID()
    let name: String
    let wordCount: Int
    let progress: Double
    let struggling: Int
    let progressing: Int
    let mastered: Int
}

// MARK: - Word List Card
struct WordListCard: View {
    let list: WordList
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(list.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(list.wordCount) words")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(Color.accentPurple)
                        .frame(width: geometry.size.width * list.progress, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
            
            Text("\(Int(list.progress * 100))% Overall Progress")
                .font(.subheadline)
                .fontWeight(.medium)
            
            HStack(spacing: 16) {
                StatusLabel(count: list.struggling, label: "Struggling", color: .red)
                StatusLabel(count: list.progressing, label: "Progressing", color: .orange)
                StatusLabel(count: list.mastered, label: "Mastered", color: .green)
            }
            .font(.caption)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Status Label
struct StatusLabel: View {
    let count: Int
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Text("\(count)")
                .fontWeight(.semibold)
            Text(label)
        }
        .foregroundColor(color)
    }
}

// MARK: - Tab Button
struct TabButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? Color.accentPurple : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    WordListsView()
}
