//
//  QuizSessionView.swift
//  vocabflow
//
//  Created by Kevin Sofyan on 29/01/26.
//

import SwiftUI

struct QuizSessionView: View {
    @Environment(\.dismiss) private var dismiss
    
    let wordList: SessionWordList
    let words: [String]
    
    @State private var currentQuestion = 0
    @State private var selectedAnswer: Int?
    @State private var showFeedback = false
    @State private var isCorrect = false
    @State private var score = 0
    @State private var showSummary = false
    @State private var masteredWords: [String] = []
    
    private var quizQuestions: [QuizQuestion] {
        // Generate quiz questions from words
        words.enumerated().map { index, word in
            QuizQuestion(
                word: word,
                correctDefinition: getDefinition(for: word),
                wrongAnswers: getWrongAnswers(excluding: word)
            )
        }
    }
    
    var body: some View {
        ZStack {
            if showSummary {
                // Session Summary
                VStack(spacing: 24) {
                    Text("Session Complete!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 16) {
                        Text("Session Score")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("\(score)/\(words.count)")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.accentPurple)
                        
                        Text("Fantastic effort! You're a vocabulary superstar!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // Mastered Words
                    if !masteredWords.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Words You Mastered!")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ScrollView {
                                VStack(spacing: 12) {
                                    ForEach(masteredWords, id: \.self) { word in
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(word.capitalized)
                                                    .font(.headline)
                                                Text(getDefinition(for: word))
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            Spacer()
                                            
                                            HStack(spacing: 4) {
                                                Image(systemName: "star.fill")
                                                    .font(.caption2)
                                                Text("Mastery Up!")
                                                    .font(.caption2)
                                                    .fontWeight(.medium)
                                            }
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color.cyan)
                                            .cornerRadius(12)
                                        }
                                        .padding()
                                        .background(Color(UIColor.systemBackground))
                                        .cornerRadius(12)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Done")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.accentPurple)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color(UIColor.systemGroupedBackground))
            } else if showFeedback {
                // Feedback View
                VStack(spacing: 32) {
                    Spacer()
                    
                    // Success Animation Placeholder
                    ZStack {
                        Circle()
                            .fill(Color.yellow.opacity(0.2))
                            .frame(width: 150, height: 150)
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                    }
                    
                    VStack(spacing: 16) {
                        Text("Great Job!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.accentPurple)
                        
                        Text(isCorrect ? "You understood the meaning perfectly! Keep up the amazing work." : "That's okay! Keep practicing and you'll master it.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Text("Animation Placeholder")
                            .font(.caption)
                            .foregroundColor(.secondary.opacity(0.5))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        nextQuestion()
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.accentPurple)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
                .background(Color(UIColor.systemGroupedBackground))
            } else {
                // Quiz View
                VStack(spacing: 0) {
                    // Question Header
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Question \(currentQuestion + 1) of \(words.count)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: "text.book.closed.fill")
                                    .font(.caption2)
                                Text("Meaning Quiz")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.cyan)
                            .cornerRadius(12)
                        }
                        
                        Text("What is the meaning of the word '\(quizQuestions[currentQuestion].word)'?")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        // Image placeholder
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .aspectRatio(16/9, contentMode: .fit)
                            
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundColor(.gray.opacity(0.3))
                        }
                        .cornerRadius(12)
                    }
                    .padding()
                    
                    // Answer Options
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(0..<quizQuestions[currentQuestion].allAnswers.count, id: \.self) { index in
                                Button(action: {
                                    selectedAnswer = index
                                }) {
                                    Text(quizQuestions[currentQuestion].allAnswers[index])
                                        .font(.body)
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color(UIColor.systemBackground))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(selectedAnswer == index ? Color.accentPurple : Color.clear, lineWidth: 2)
                                                )
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
                    
                    // Submit Button
                    VStack(spacing: 0) {
                        Button(action: {
                            checkAnswer()
                        }) {
                            Text("Submit Answer")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(selectedAnswer != nil ? Color.accentPurple : Color.gray)
                                .cornerRadius(12)
                        }
                        .disabled(selectedAnswer == nil)
                        .padding(.horizontal)
                        .padding(.vertical, 16)
                    }
                    .background(Color(UIColor.systemBackground))
                }
                .background(Color(UIColor.systemGroupedBackground))
            }
        }
        .navigationTitle(showSummary ? "" : "Quiz Time")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            if !showSummary && !showFeedback {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    private func checkAnswer() {
        guard let selected = selectedAnswer else { return }
        
        let question = quizQuestions[currentQuestion]
        isCorrect = question.allAnswers[selected] == question.correctDefinition
        
        if isCorrect {
            score += 1
            masteredWords.append(question.word)
        }
        
        showFeedback = true
    }
    
    private func nextQuestion() {
        selectedAnswer = nil
        showFeedback = false
        
        if currentQuestion < words.count - 1 {
            currentQuestion += 1
        } else {
            showSummary = true
        }
    }
    
    private func getDefinition(for word: String) -> String {
        // Sample definitions - in production, fetch from actual word database
        let definitions: [String: String] = [
            "ancient": "Very old; from a long time ago",
            "winding": "Having many bends and turns",
            "enchanting": "Delightfully charming or attractive",
            "majestic": "Having impressive beauty or dignity",
            "wonder": "A feeling of amazement and admiration",
            "shimmering": "Shining with a soft, wavering light",
            "rustling": "Making soft sounds like leaves moving",
            "gentle": "Mild, soft, or tender",
            "exploring": "Traveling through to learn about",
            "trusty": "Reliable and faithful",
            "rumored": "Said to be true by people but not confirmed",
            "dappled": "Marked with spots or patches of light"
        ]
        return definitions[word.lowercased()] ?? "A wonderful word to learn"
    }
    
    private func getWrongAnswers(excluding word: String) -> [String] {
        let allDefinitions = [
            "To shine brightly, especially with reflected light",
            "To make a loud, ringing sound",
            "To move very quickly and silently",
            "To feel a deep sadness or sorrow",
            "Calm, peaceful, and untroubled",
            "Present, appearing, or found everywhere",
            "Able to withstand or recover quickly from difficult conditions"
        ]
        return Array(allDefinitions.shuffled().prefix(3))
    }
}

// MARK: - Quiz Question Model
struct QuizQuestion {
    let word: String
    let correctDefinition: String
    let wrongAnswers: [String]
    
    var allAnswers: [String] {
        ([correctDefinition] + wrongAnswers).shuffled()
    }
}

#Preview {
    NavigationStack {
        QuizSessionView(
            wordList: SessionWordList(name: "Animals & Nature", wordCount: 12, type: .new),
            words: ["ancient", "winding", "enchanting", "majestic", "wonder"]
        )
    }
}
