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
    @State private var showAddWordSheet: Bool = false
    @State private var selectedWord: WordItem? = nil
    
    @State private var words = [
        WordItem(name: "Elephant", definition: "A large mammal with a trunk", spellingProgress: 0.9, meaningProgress: 0.85, status: .mastered, allowSpelling: true, allowMeaning: true),
        WordItem(name: "Giraffe", definition: "Tall animal with a long neck", spellingProgress: 0.3, meaningProgress: 0.4, status: .struggling, allowSpelling: true, allowMeaning: true),
        WordItem(name: "Zebra", definition: "Horse-like animal with stripes", spellingProgress: 0.6, meaningProgress: 0.65, status: .progressing, allowSpelling: true, allowMeaning: true),
        WordItem(name: "Lion", definition: "King of the jungle", spellingProgress: 0.95, meaningProgress: 0.9, status: .mastered, allowSpelling: true, allowMeaning: true),
        WordItem(name: "Tiger", definition: "Large striped feline", spellingProgress: 0.4, meaningProgress: 0.35, status: .struggling, allowSpelling: true, allowMeaning: true),
        WordItem(name: "Monkey", definition: "Primate that swings from trees", spellingProgress: 0.7, meaningProgress: 0.68, status: .progressing, allowSpelling: true, allowMeaning: true),
        WordItem(name: "Panda", definition: "Black and white bear from China", spellingProgress: 0.2, meaningProgress: 0.25, status: .struggling, allowSpelling: true, allowMeaning: true),
        WordItem(name: "Kangaroo", definition: "Hopping marsupial from Australia", spellingProgress: 0.65, meaningProgress: 0.7, status: .progressing, allowSpelling: true, allowMeaning: true),
        WordItem(name: "Dolphin", definition: "Intelligent marine mammal", spellingProgress: 0.88, meaningProgress: 0.92, status: .mastered, allowSpelling: true, allowMeaning: true),
        WordItem(name: "Penguin", definition: "Flightless bird that swims", spellingProgress: 0.35, meaningProgress: 0.3, status: .struggling, allowSpelling: true, allowMeaning: true)
    ]
    
    @State private var priorityWords: Set<UUID> = []
    
    private var filteredWords: [WordItem] {
        var result = words
        
        // Apply search filter
        if !searchText.isEmpty {
            result = result.filter { word in
                word.name.localizedCaseInsensitiveContains(searchText) ||
                word.definition.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply status filters (if any are active, show only those statuses)
        if showStruggling || showMastered {
            result = result.filter { word in
                (showStruggling && word.status == .struggling) ||
                (showMastered && word.status == .mastered)
            }
        }
        
        // Apply priority filter
        if showPriority {
            result = result.filter { priorityWords.contains($0.id) }
        }
        
        return result
    }
    
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
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        FilterToggle(icon: "exclamationmark.triangle", label: "Show struggling", isOn: $showStruggling)
                        FilterToggle(icon: "checkmark.circle", label: "Show mastered", isOn: $showMastered)
                    }
                    
                    HStack(spacing: 12) {
                        FilterToggle(icon: "star", label: "Show priority", isOn: $showPriority)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Add New Word Button
                Button(action: { showAddWordSheet = true }) {
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
                    if filteredWords.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("No words found")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("Try adjusting your search or filters")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        ForEach(filteredWords) { word in
                            WordItemRow(word: word, isPriority: priorityWords.contains(word.id)) {
                                if priorityWords.contains(word.id) {
                                    priorityWords.remove(word.id)
                                } else {
                                    priorityWords.insert(word.id)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedWord = word
                            }
                            
                            if word.id != filteredWords.last?.id {
                                Divider()
                                    .padding(.horizontal)
                            }
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
        .sheet(isPresented: $showAddWordSheet) {
            AddNewWordSheet { newWord in
                words.append(newWord)
            }
        }
        .sheet(item: $selectedWord) { word in
            WordDetailSheet(word: word) { updatedWord in
                if let index = words.firstIndex(where: { $0.id == updatedWord.id }) {
                    words[index] = updatedWord
                }
            }
        }
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
    var name: String
    var definition: String
    var spellingProgress: Double
    var meaningProgress: Double
    var status: WordStatus
    var allowSpelling: Bool
    var allowMeaning: Bool
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
    let isPriority: Bool
    var onTogglePriority: () -> Void
    
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
                
                Button(action: onTogglePriority) {
                    Image(systemName: isPriority ? "star.fill" : "star")
                        .foregroundColor(isPriority ? .yellow : .gray)
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

// MARK: - Add New Word Sheet
struct AddNewWordSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var newWord: String = ""
    @State private var definition: String = ""
    @State private var allowSpelling: Bool = true
    @State private var allowMeaning: Bool = true
    
    var onAdd: (WordItem) -> Void
    
    private var isValidWord: Bool {
        !newWord.isEmpty && !newWord.contains(" ") && (allowSpelling || allowMeaning)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Word")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    TextField("Enter a word (no spaces)", text: $newWord)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: newWord) { _, newValue in
                            // Remove spaces as user types
                            if newValue.contains(" ") {
                                newWord = newValue.replacingOccurrences(of: " ", with: "")
                            }
                        }
                    
                    if newWord.isEmpty {
                        Text("Word cannot be empty")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Definition (optional)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    TextField("Enter definition", text: $definition, axis: .vertical)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .lineLimit(3...6)
                }
                
                // Practice Options
                VStack(alignment: .leading, spacing: 12) {
                    Text("Practice Options")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Toggle(isOn: $allowSpelling) {
                        HStack(spacing: 8) {
                            Image(systemName: "character.cursor.ibeam")
                                .foregroundColor(.accentPurple)
                            Text("Allow Spelling Practice")
                        }
                    }
                    .tint(.accentPurple)
                    
                    Toggle(isOn: $allowMeaning) {
                        HStack(spacing: 8) {
                            Image(systemName: "book")
                                .foregroundColor(.accentPurple)
                            Text("Allow Meaning Practice")
                        }
                    }
                    .tint(.accentPurple)
                    
                    if !allowSpelling && !allowMeaning {
                        Text("At least one practice option must be selected")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                
                Spacer()
                
                Button(action: {
                    let word = WordItem(
                        name: newWord,
                        definition: definition,
                        spellingProgress: 0.0,
                        meaningProgress: 0.0,
                        status: .struggling,
                        allowSpelling: allowSpelling,
                        allowMeaning: allowMeaning
                    )
                    onAdd(word)
                    dismiss()
                }) {
                    Text("Add Word")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(isValidWord ? Color.accentPurple : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!isValidWord)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Add New Word")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.accentPurple)
                }
            }
        }
        .presentationDetents([.large])
        .presentationBackground(Color(UIColor.systemBackground))
    }
}

// MARK: - Word Detail Sheet (Edit)
struct WordDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var editedWord: String
    @State private var editedDefinition: String
    @State private var allowSpelling: Bool
    @State private var allowMeaning: Bool
    
    let word: WordItem
    var onSave: (WordItem) -> Void
    
    init(word: WordItem, onSave: @escaping (WordItem) -> Void) {
        self.word = word
        self.onSave = onSave
        _editedWord = State(initialValue: word.name)
        _editedDefinition = State(initialValue: word.definition)
        _allowSpelling = State(initialValue: word.allowSpelling)
        _allowMeaning = State(initialValue: word.allowMeaning)
    }
    
    private var isValidWord: Bool {
        !editedWord.isEmpty && !editedWord.contains(" ") && (allowSpelling || allowMeaning)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Word Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Word")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        TextField("Enter a word (no spaces)", text: $editedWord)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .onChange(of: editedWord) { _, newValue in
                                if newValue.contains(" ") {
                                    editedWord = newValue.replacingOccurrences(of: " ", with: "")
                                }
                            }
                        
                        if editedWord.isEmpty {
                            Text("Word cannot be empty")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Definition")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        TextField("Enter definition", text: $editedDefinition, axis: .vertical)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                            .lineLimit(3...6)
                    }
                    
                    // Practice Options
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Practice Options")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Toggle(isOn: $allowSpelling) {
                            HStack(spacing: 8) {
                                Image(systemName: "character.cursor.ibeam")
                                    .foregroundColor(.accentPurple)
                                Text("Allow Spelling Practice")
                            }
                        }
                        .tint(.accentPurple)
                        
                        Toggle(isOn: $allowMeaning) {
                            HStack(spacing: 8) {
                                Image(systemName: "book")
                                    .foregroundColor(.accentPurple)
                                Text("Allow Meaning Practice")
                            }
                        }
                        .tint(.accentPurple)
                        
                        if !allowSpelling && !allowMeaning {
                            Text("At least one practice option must be selected")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    
                    // Progress Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Progress")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Spelling")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(Int(word.spellingProgress * 100))%")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.accentPurple)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Meaning")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(Int(word.meaningProgress * 100))%")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.accentPurple)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Status")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(word.status.label)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(word.status.color)
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    
                    Button(action: {
                        var updatedWord = word
                        updatedWord.name = editedWord
                        updatedWord.definition = editedDefinition
                        updatedWord.allowSpelling = allowSpelling
                        updatedWord.allowMeaning = allowMeaning
                        onSave(updatedWord)
                        dismiss()
                    }) {
                        Text("Save Changes")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(isValidWord ? Color.accentPurple : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!isValidWord)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Word Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.accentPurple)
                }
            }
        }
        .presentationDetents([.large])
        .presentationBackground(Color(UIColor.systemBackground))
    }
}

#Preview {
    NavigationStack {
        ListDetailView(listName: "Animals Vocabulary")
    }
}
