//
//  ListDetailView.swift
//  vocabflow
//
//  Created by Kevin Sofyan on 21/01/26.
//

import SwiftUI

struct ListDetailView: View {
    let listName: String
    @State private var searchText: String = ""
    @State private var showStruggling: Bool = false
    @State private var showMastered: Bool = false
    @State private var showPriority: Bool = false
    
    let words = [
        WordItem(name: "Elephant", spellingProgress: 0.9, meaningProgress: 0.85, status: .mastered),
        WordItem(name: "Giraffe", spellingProgress: 0.3, meaningProgress: 0.4, status: .struggling),
        WordItem(name: "Zebra", spellingProgress: 0.6, meaningProgress: 0.65, status: .progressing),
        WordItem(name: "Lion", spellingProgress: 0.95, meaningProgress: 0.9, status: .mastered),
        WordItem(name: "Tiger", spellingProgress: 0.4, meaningProgress: 0.35, status: .struggling),
        WordItem(name: "Monkey", spellingProgress: 0.7, meaningProgress: 0.68, status: .progressing),
        WordItem(name: "Panda", spellingProgress: 0.2, meaningProgress: 0.25, status: .struggling),
        WordItem(name: "Kangaroo", spellingProgress: 0.65, meaningProgress: 0.7, status: .progressing),
        WordItem(name: "Dolphin", spellingProgress: 0.88, meaningProgress: 0.92, status: .mastered),
        WordItem(name: "Penguin", spellingProgress: 0.35, meaningProgress: 0.3, status: .struggling)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search words...", text: $searchText)
                }
                .padding(12)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Filter Toggles
                HStack(spacing: 12) {
                    FilterToggle(icon: "exclamationmark.triangle", label: "Show struggling", isOn: $showStruggling)
                    FilterToggle(icon: "checkmark.circle", label: "Show mastered", isOn: $showMastered)
                }
                .padding(.horizontal)
                
                HStack {
                    FilterToggle(icon: "star", label: "Show priority", isOn: $showPriority)
                    Spacer()
                }
                .padding(.horizontal)
                
                // Add New Word Button
                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add New Word")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.accentPurple)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Bulk Actions
                HStack {
                    Text("Bulk Actions")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal)
                
                // Word List
                VStack(spacing: 0) {
                    ForEach(words) { word in
                        WordItemRow(word: word)
                        
                        if word.id != words.last?.id {
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle(listName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: DashboardView()) {
                    Image(systemName: "house.fill")
                        .foregroundColor(.accentPurple)
                }
            }
        }
    }
}

// MARK: - Word Item Model
struct WordItem: Identifiable {
    let id = UUID()
    let name: String
    let spellingProgress: Double
    let meaningProgress: Double
    let status: WordStatus
}

enum WordStatus {
    case struggling
    case progressing
    case mastered
    
    var color: Color {
        switch self {
        case .struggling: return .red
        case .progressing: return .orange
        case .mastered: return .green
        }
    }
    
    var label: String {
        switch self {
        case .struggling: return "Struggling"
        case .progressing: return "Progressing"
        case .mastered: return "Mastered"
        }
    }
}

// MARK: - Filter Toggle
struct FilterToggle: View {
    let icon: String
    let label: String
    @Binding var isOn: Bool
    
    var body: some View {
        Button(action: { isOn.toggle() }) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(label)
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isOn ? Color.accentPurple.opacity(0.1) : Color(UIColor.systemBackground))
            .foregroundColor(isOn ? Color.accentPurple : .gray)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isOn ? Color.accentPurple : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// MARK: - Word Item Row
struct WordItemRow: View {
    let word: WordItem
    @State private var isFavorite: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 12) {
                Text(word.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // Spelling Progress
                VStack(alignment: .leading, spacing: 4) {
                    Text("Spelling")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 6)
                                .cornerRadius(3)
                            
                            Rectangle()
                                .fill(Color.accentPurple)
                                .frame(width: geometry.size.width * word.spellingProgress, height: 6)
                                .cornerRadius(3)
                        }
                    }
                    .frame(height: 6)
                }
                
                // Meaning Progress
                VStack(alignment: .leading, spacing: 4) {
                    Text("Meaning")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 6)
                                .cornerRadius(3)
                            
                            Rectangle()
                                .fill(Color.accentPurple)
                                .frame(width: geometry.size.width * word.meaningProgress, height: 6)
                                .cornerRadius(3)
                        }
                    }
                    .frame(height: 6)
                }
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                Text(word.status.label)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(word.status.color)
                
                Button(action: { isFavorite.toggle() }) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? .yellow : .gray)
                }
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        ListDetailView(listName: "Animals Vocabulary")
    }
}
