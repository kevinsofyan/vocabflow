//
//  StorySessionView.swift
//  vocabflow
//
//  Created by Kevin Sofyan on 29/01/26.
//

import SwiftUI

// MARK: - Story Session Constants
private let MIN_SLIDES = 10
private let MAX_SLIDES = 20
private let MAX_WORDS_PER_SLIDE = 150
private let MIN_VOCABULARY_WORDS_PER_SLIDE = 3
private let MAX_VOCABULARY_WORDS_PER_SLIDE = 5

struct StorySessionView: View {
    @Environment(\.dismiss) private var dismiss
    
    let wordList: SessionWordList
    let words: [String]
    
    @State private var storySlides: [StorySlide] = []
    @State private var currentSlide = 0
    @State private var isGenerating = true
    @State private var showPauseDialog = false
    @State private var showSuccessDialog = false
    
    var body: some View {
        ZStack {
            if isGenerating {
                // Loading State
                VStack(spacing: 24) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.accentPurple)
                    
                    VStack(spacing: 8) {
                        Text("Creating Your Story...")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Generating an engaging story with your words")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
            } else {
                // Story Mode
                VStack(spacing: 0) {
                    // Story Content
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Image placeholder
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .aspectRatio(16/9, contentMode: .fit)
                                
                                Image(systemName: "photo")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                            .cornerRadius(16)
                            
                            // Story Text
                            Text(storySlides[currentSlide].attributedText)
                                .font(.body)
                                .lineSpacing(8)
                                .padding(.horizontal)
                        }
                        .padding()
                    }
                    
                    // Navigation Controls
                    VStack(spacing: 16) {
                        // Progress
                        HStack {
                            Text("Slide \(currentSlide + 1) of \(storySlides.count)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // Buttons
                        HStack(spacing: 12) {
                            // Previous
                            Button(action: {
                                if currentSlide > 0 {
                                    currentSlide -= 1
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title3)
                                    .foregroundColor(currentSlide > 0 ? .primary : .gray)
                                    .frame(width: 50, height: 50)
                                    .background(Color(UIColor.systemBackground))
                                    .cornerRadius(25)
                            }
                            .disabled(currentSlide == 0)
                            
                            // Pause
                            Button(action: {
                                showPauseDialog = true
                            }) {
                                HStack {
                                    Image(systemName: "pause.fill")
                                    Text("Pause")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.accentPurple)
                                .cornerRadius(25)
                            }
                            
                            // Next
                            Button(action: {
                                if currentSlide < storySlides.count - 1 {
                                    currentSlide += 1
                                } else {
                                    // Reached the end
                                    showSuccessDialog = true
                                }
                            }) {
                                Image(systemName: currentSlide < storySlides.count - 1 ? "chevron.right" : "checkmark")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                    .frame(width: 50, height: 50)
                                    .background(currentSlide < storySlides.count - 1 ? Color(UIColor.systemBackground) : Color.accentPurple)
                                    .cornerRadius(25)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 16)
                    .background(Color(UIColor.systemGroupedBackground))
                }
            }
            
            // Custom Pause Dialog
            if showPauseDialog {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showPauseDialog = false
                    }
                
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Text("Pause your learning session?")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("You're on slide \(currentSlide + 1) of \(storySlides.count).")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            showPauseDialog = false
                        }) {
                            Text("Keep Going")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.accentPurple)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Pause & Save")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.red)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(24)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 20)
                .padding(.horizontal, 40)
            }
            
            // Success Dialog
            if showSuccessDialog {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 24) {
                    // Success Icon
                    ZStack {
                        Circle()
                            .fill(Color.accentPurple.opacity(0.2))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.accentPurple)
                    }
                    
                    VStack(spacing: 12) {
                        Text("Great Job!")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("You've completed the story session!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text("Learned \(words.count) new words")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.accentPurple)
                    }
                    
                    VStack(spacing: 12) {
                        NavigationLink(destination: QuizSessionView(wordList: wordList, words: words)) {
                            Text("Take the Quiz")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.accentPurple)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Back to Dashboard")
                                .font(.headline)
                                .foregroundColor(.accentPurple)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.accentPurple.opacity(0.1))
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            currentSlide = 0
                            showSuccessDialog = false
                        }) {
                            Text("Review Story")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(32)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 20)
                .padding(.horizontal, 40)
            }
        }
        .navigationTitle(isGenerating ? "" : "Story Time")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            if !isGenerating {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showPauseDialog = true }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .onAppear {
            generateStory()
        }
    }
    
    private func generateStory() {
        // Simulate story generation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // For now, generate sample story with the words
            let sampleStories = generateSampleStories()
            storySlides = sampleStories
            isGenerating = false
        }
    }
    
    private func generateSampleStories() -> [StorySlide] {
        // Sample story generation - in production, this would use Apple's Foundation LLM
        var stories: [StorySlide] = []
        
        // Generate at least MIN_SLIDES stories
        let storyTexts = [
            "Lily and her trusty dog, Sparky, loved exploring the Whispering Woods. Today, their mission was to find the ancient tree, rumored to grant wishes. The path was winding and dappled with sunlight, making their adventure even more enchanting.",
            "The ancient tree stood tall and majestic, its branches reaching towards the sky. Lily approached carefully, feeling a sense of wonder wash over her. She closed her eyes and made a wish, hoping it would come true.",
            "As they walked back home, Lily couldn't stop thinking about the enchanting experience. The woods felt more alive than ever, with birds singing and leaves rustling in the gentle breeze. She knew this adventure would stay with her forever.",
            "The next morning, Lily woke up excited to tell her friends about the magical tree. She wondered if her wish would really come true. The ancient tree had seemed so powerful and mysterious.",
            "At school, Lily shared her story with her classmates. Some believed her, while others thought it was just her imagination. But Lily knew what she had experienced was real and special.",
            "Days passed, and Lily often thought about the winding path through the woods. She wanted to return to the ancient tree again. Perhaps she would discover more secrets hidden in the forest.",
            "One afternoon, Lily decided to go back with Sparky. The journey felt even more enchanting this time. Every rustling leaf and gentle breeze seemed to whisper secrets of the woods.",
            "As they approached the clearing, Lily noticed something different. The ancient tree seemed to glow with a soft, warm light. It was as if the tree was welcoming them back.",
            "Sparky barked excitedly and ran around the tree. Lily laughed and followed him. The majestic tree stood firm, its branches swaying gently in the wind. She felt a deep connection to this magical place.",
            "Lily sat beneath the tree and opened her notebook. She began writing about all her adventures in the Whispering Woods. The ancient tree would be the guardian of all her stories and dreams."
        ]
        
        // Ensure we have at least MIN_SLIDES
        for i in 0..<max(MIN_SLIDES, min(storyTexts.count, MAX_SLIDES)) {
            let text = storyTexts[i % storyTexts.count]
            let vocabCount = Int.random(in: MIN_VOCABULARY_WORDS_PER_SLIDE...MAX_VOCABULARY_WORDS_PER_SLIDE)
            stories.append(StorySlide(
                text: text,
                highlightedWords: Array(words.shuffled().prefix(vocabCount))
            ))
        }
        
        return stories
    }
}

// MARK: - Story Slide Model
struct StorySlide: Identifiable {
    let id = UUID()
    let text: String
    let highlightedWords: [String]
    
    var attributedText: AttributedString {
        var attributed = AttributedString(text)
        
        for word in highlightedWords {
            // Find and highlight each word
            var searchRange = attributed.startIndex..<attributed.endIndex
            while let range = attributed[searchRange].range(of: word, options: [.caseInsensitive, .diacriticInsensitive]) {
                attributed[range].foregroundColor = .accentPurple
                attributed[range].font = .body.bold()
                
                // Move search range forward
                if range.upperBound < attributed.endIndex {
                    searchRange = range.upperBound..<attributed.endIndex
                } else {
                    break
                }
            }
        }
        
        return attributed
    }
}

#Preview {
    NavigationStack {
        StorySessionView(
            wordList: SessionWordList(name: "Animals & Nature", wordCount: 12, type: .new),
            words: ["ancient", "winding", "enchanting", "majestic", "wonder"]
        )
    }
}
