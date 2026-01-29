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
    @State private var addedWords: [NewWordEntry] = []
    @State private var showAddWordsSheet: Bool = false
    @State private var selectedWordPack: WordPack? = nil
    var isOnboarding: Bool = false
    
    let wordPacks = [
        WordPack(
            title: "Grade 2 Vocabulary",
            description: "Essential words for 7-8 year olds.",
            imageName: "book.fill",
            backgroundColor: Color.red.opacity(0.2),
            words: [
                PrefilledWord(word: "Butterfly", definition: "An insect with colorful wings"),
                PrefilledWord(word: "Rainbow", definition: "An arc of colors in the sky"),
                PrefilledWord(word: "Dolphin", definition: "A smart sea mammal"),
                PrefilledWord(word: "Mountain", definition: "A very tall landform"),
                PrefilledWord(word: "Discover", definition: "To find something new"),
                PrefilledWord(word: "Courage", definition: "Being brave"),
                PrefilledWord(word: "Treasure", definition: "Something valuable"),
                PrefilledWord(word: "Adventure", definition: "An exciting journey")
            ]
        ),
        WordPack(
            title: "SAT Prep Words",
            description: "High-frequency words for college entrance exams.",
            imageName: "graduationcap.fill",
            backgroundColor: Color.blue.opacity(0.2),
            words: [
                PrefilledWord(word: "Ubiquitous", definition: "Present everywhere"),
                PrefilledWord(word: "Ephemeral", definition: "Lasting a very short time"),
                PrefilledWord(word: "Pragmatic", definition: "Dealing with things practically"),
                PrefilledWord(word: "Ambiguous", definition: "Having multiple meanings"),
                PrefilledWord(word: "Eloquent", definition: "Fluent and persuasive in speech"),
                PrefilledWord(word: "Meticulous", definition: "Very careful and precise"),
                PrefilledWord(word: "Benevolent", definition: "Well-meaning and kind"),
                PrefilledWord(word: "Resilient", definition: "Able to recover quickly")
            ]
        ),
        WordPack(
            title: "Science Terms",
            description: "Common scientific vocabulary for kids.",
            imageName: "flask.fill",
            backgroundColor: Color.green.opacity(0.2),
            words: [
                PrefilledWord(word: "Hypothesis", definition: "An educated guess"),
                PrefilledWord(word: "Experiment", definition: "A test to prove something"),
                PrefilledWord(word: "Molecule", definition: "Tiny particles of matter"),
                PrefilledWord(word: "Gravity", definition: "Force that pulls things down"),
                PrefilledWord(word: "Ecosystem", definition: "Living things in an environment"),
                PrefilledWord(word: "Photosynthesis", definition: "How plants make food"),
                PrefilledWord(word: "Evolution", definition: "Change over time"),
                PrefilledWord(word: "Organism", definition: "A living thing")
            ]
        )
    ]
    
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
                        
                        // Words Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Words")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Text("\(addedWords.count) words")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            // Add Words Button
                            Button(action: { showAddWordsSheet = true }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title3)
                                    Text("Add Words")
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(.accentPurple)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.accentPurple.opacity(0.1))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.accentPurple.opacity(0.3), lineWidth: 1)
                                )
                            }
                            
                            // Added Words List
                            if !addedWords.isEmpty {
                                VStack(spacing: 0) {
                                    ForEach(addedWords) { word in
                                        HStack {
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(word.word)
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                
                                                HStack(spacing: 8) {
                                                    if word.allowSpelling {
                                                        Label("Spelling", systemImage: "character.cursor.ibeam")
                                                            .font(.caption2)
                                                            .foregroundColor(.secondary)
                                                    }
                                                    if word.allowMeaning {
                                                        Label("Meaning", systemImage: "book")
                                                            .font(.caption2)
                                                            .foregroundColor(.secondary)
                                                    }
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                addedWords.removeAll { $0.id == word.id }
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 12)
                                        
                                        if word.id != addedWords.last?.id {
                                            Divider()
                                        }
                                    }
                                }
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        
                        // Create List Button
                        Button(action: {
                            // Handle create list
                        }) {
                            Text("Create List")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(!listName.isEmpty && !addedWords.isEmpty ? Color.accentPurple : Color.gray)
                                .cornerRadius(12)
                        }
                        .disabled(listName.isEmpty || addedWords.isEmpty)
                        
                        // Skip Button
                        NavigationLink(destination: DashboardView()) {
                            Text("Skip for now")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
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
                            ForEach(wordPacks) { pack in
                                WordPackCard(pack: pack) {
                                    selectedWordPack = pack
                                }
                            }
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
        .sheet(isPresented: $showAddWordsSheet) {
            AddMultipleWordsSheet { newWords in
                addedWords.append(contentsOf: newWords)
            }
        }
        .sheet(item: $selectedWordPack) { pack in
            WordPackDetailSheet(pack: pack) { selectedWords in
                addedWords.append(contentsOf: selectedWords)
                if listName.isEmpty {
                    listName = pack.title
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

// MARK: - New Word Entry Model
struct NewWordEntry: Identifiable {
    let id = UUID()
    var word: String
    var definition: String
    var allowSpelling: Bool
    var allowMeaning: Bool
}

// MARK: - Add Multiple Words Sheet
struct AddMultipleWordsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var wordEntries: [EditableWordEntry] = [EditableWordEntry()]
    
    var onAdd: ([NewWordEntry]) -> Void
    
    private var validWords: [NewWordEntry] {
        wordEntries.compactMap { entry in
            let trimmed = entry.word.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty && !trimmed.contains(" ") && (entry.allowSpelling || entry.allowMeaning) else { return nil }
            return NewWordEntry(
                word: trimmed,
                definition: entry.definition,
                allowSpelling: entry.allowSpelling,
                allowMeaning: entry.allowMeaning
            )
        }
    }
    
    private var canAdd: Bool {
        !validWords.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Word Entries
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Words")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("\(validWords.count) valid")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        ForEach($wordEntries) { $entry in
                            WordEntryRow(entry: $entry) {
                                wordEntries.removeAll { $0.id == entry.id }
                                if wordEntries.isEmpty {
                                    wordEntries.append(EditableWordEntry())
                                }
                            }
                        }
                        
                        // Add Another Word Button
                        Button(action: {
                            wordEntries.append(EditableWordEntry())
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Another Word")
                            }
                            .font(.subheadline)
                            .foregroundColor(.accentPurple)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.accentPurple.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    
                    Button(action: {
                        onAdd(validWords)
                        dismiss()
                    }) {
                        Text("Add \(validWords.count) Word\(validWords.count == 1 ? "" : "s")")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(canAdd ? Color.accentPurple : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!canAdd)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Add Words")
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

// MARK: - Editable Word Entry
struct EditableWordEntry: Identifiable {
    let id = UUID()
    var word: String = ""
    var definition: String = ""
    var allowSpelling: Bool = true
    var allowMeaning: Bool = true
}

// MARK: - Word Entry Row
struct WordEntryRow: View {
    @Binding var entry: EditableWordEntry
    var onDelete: () -> Void
    
    private var hasError: Bool {
        !entry.word.isEmpty && entry.word.contains(" ")
    }
    
    private var needsPracticeOption: Bool {
        !entry.word.isEmpty && !entry.allowSpelling && !entry.allowMeaning
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                VStack(spacing: 8) {
                    TextField("Word (no spaces)", text: $entry.word)
                        .textFieldStyle(.plain)
                        .padding(10)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: entry.word) { _, newValue in
                            if newValue.contains(" ") {
                                entry.word = newValue.replacingOccurrences(of: " ", with: "")
                            }
                        }
                    
                    TextField("Definition (optional)", text: $entry.definition)
                        .textFieldStyle(.plain)
                        .padding(10)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                        .font(.subheadline)
                    
                    // Practice Options
                    HStack(spacing: 12) {
                        Toggle(isOn: $entry.allowSpelling) {
                            HStack(spacing: 4) {
                                Image(systemName: "character.cursor.ibeam")
                                    .font(.caption2)
                                Text("Spelling")
                                    .font(.caption)
                            }
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        
                        Toggle(isOn: $entry.allowMeaning) {
                            HStack(spacing: 4) {
                                Image(systemName: "book")
                                    .font(.caption2)
                                Text("Meaning")
                                    .font(.caption)
                            }
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        
                        Spacer()
                    }
                    
                    if needsPracticeOption {
                        Text("Select at least one practice type")
                            .font(.caption2)
                            .foregroundColor(.red)
                    }
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red.opacity(0.7))
                        .padding(10)
                }
            }
        }
        .padding(12)
        .background(Color(UIColor.tertiarySystemBackground))
        .cornerRadius(10)
    }
}

// MARK: - Checkbox Toggle Style
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack(spacing: 6) {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? .accentPurple : .gray)
                    .font(.system(size: 16))
                configuration.label
                    .foregroundColor(configuration.isOn ? .primary : .secondary)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Word Pack Model
struct WordPack: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    let backgroundColor: Color
    let words: [PrefilledWord]
}

struct PrefilledWord: Identifiable {
    let id = UUID()
    let word: String
    let definition: String
}

// MARK: - Word Pack Card
struct WordPackCard: View {
    let pack: WordPack
    var onViewPack: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(pack.backgroundColor)
                    .frame(height: 140)
                
                Image(systemName: pack.imageName)
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            
            // Title
            Text(pack.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            // Description
            Text(pack.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .frame(height: 36)
            
            // Word count
            Text("\(pack.words.count) words")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // View Pack Button
            Button(action: onViewPack) {
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

// MARK: - Word Pack Detail Sheet
struct WordPackDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let pack: WordPack
    var onAddWords: ([NewWordEntry]) -> Void
    
    @State private var globalAllowSpelling: Bool = true
    @State private var globalAllowMeaning: Bool = true
    
    private var canAdd: Bool {
        globalAllowSpelling || globalAllowMeaning
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Pack Header
                    VStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(pack.backgroundColor)
                                .frame(height: 100)
                            
                            Image(systemName: pack.imageName)
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        
                        Text(pack.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(pack.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text("\(pack.words.count) words")
                            .font(.caption)
                            .foregroundColor(.accentPurple)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.accentPurple.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Practice Options
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Practice Options")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Toggle(isOn: $globalAllowSpelling) {
                            HStack(spacing: 8) {
                                Image(systemName: "character.cursor.ibeam")
                                    .foregroundColor(.accentPurple)
                                Text("Allow Spelling Practice")
                            }
                        }
                        .tint(.accentPurple)
                        
                        Toggle(isOn: $globalAllowMeaning) {
                            HStack(spacing: 8) {
                                Image(systemName: "book")
                                    .foregroundColor(.accentPurple)
                                Text("Allow Meaning Practice")
                            }
                        }
                        .tint(.accentPurple)
                        
                        if !globalAllowSpelling && !globalAllowMeaning {
                            Text("At least one practice option must be selected")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Words Preview
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Words in this pack")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            ForEach(pack.words) { word in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(word.word)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.primary)
                                        
                                        Text(word.definition)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 12)
                                
                                if word.id != pack.words.last?.id {
                                    Divider()
                                }
                            }
                        }
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // Add Button
                    Button(action: {
                        let wordsToAdd = pack.words.map { word in
                            NewWordEntry(
                                word: word.word,
                                definition: word.definition,
                                allowSpelling: globalAllowSpelling,
                                allowMeaning: globalAllowMeaning
                            )
                        }
                        onAddWords(wordsToAdd)
                        dismiss()
                    }) {
                        Text("Add All \(pack.words.count) Words")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(canAdd ? Color.accentPurple : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!canAdd)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding(.top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Word Pack")
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
        .presentationBackground(Color(UIColor.systemGroupedBackground))
    }
}

#Preview {
    NavigationStack {
        WordInputView()
    }
}
