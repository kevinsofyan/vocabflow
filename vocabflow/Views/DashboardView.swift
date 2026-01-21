//
//  DashboardView.swift
//  vocabflow
//
//  Created by Kevin Sofyan on 19/01/26.
//

import SwiftUI
import UIKit

struct DashboardView: View {
    @State private var selectedChild: String = "Lily"

    private let children = [
        ChildProfile(name: "Lily", imageName: "person.crop.circle.fill", isPlaceholder: true),
        ChildProfile(name: "Max", imageName: "person.crop.circle.fill", isPlaceholder: true),
        ChildProfile(name: "Chloe", imageName: "person.crop.circle.fill", isPlaceholder: true)
    ]

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 24) {
                // Who's learning today
                ChildSelectorSection(
                    children: children,
                    selectedChild: $selectedChild
                )

                // Quick Stats
                QuickStatsSection()

                // What would you like to do?
                ActionButtonsSection()

                // Recent Activity
                RecentActivitySection()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 40)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {}) {
                    Image(systemName: "list.bullet.rectangle")
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

// MARK: - Child Profile Model
struct ChildProfile: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let isPlaceholder: Bool
}

// MARK: - Child Selector Section
struct ChildSelectorSection: View {
    let children: [ChildProfile]
    @Binding var selectedChild: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Who's learning today?")
                .font(.title3)
                .fontWeight(.semibold)

            HStack(spacing: 16) {
                ForEach(children) { child in
                    ChildAvatar(
                        name: child.name,
                        isSelected: selectedChild == child.name
                    ) {
                        selectedChild = child.name
                    }
                }
                
                // Add Child Button
                NavigationLink(destination: AddChildProfileView()) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .foregroundColor(Color.accentPurple.opacity(0.5))
                                .frame(width: 70, height: 70)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .foregroundColor(Color.accentPurple)
                        }
                        
                        Text("Add")
                            .font(.subheadline)
                            .foregroundColor(Color.accentPurple)
                    }
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - Child Avatar
struct ChildAvatar: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.accentPurple.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)

                    Image(systemName: "person.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.gray)
                }
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.accentPurple : Color.clear, lineWidth: 3)
                )
                .shadow(color: isSelected ? Color.accentPurple.opacity(0.3) : .clear, radius: 8)

                Text(name)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? Color.accentPurple : .primary)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Quick Stats Section
struct QuickStatsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Quick Stats")
                .font(.headline)
                .fontWeight(.semibold)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8)
            ], spacing: 8) {
                StatCard(
                    icon: "list.bullet.clipboard",
                    iconColor: Color.accentPurple,
                    title: "Total Words",
                    value: "185",
                    subtitle: nil
                )

                StatCard(
                    icon: "play.circle",
                    iconColor: Color.accentPurple,
                    title: "Learned This Week",
                    value: "12",
                    subtitle: nil
                )

                StatCard(
                    icon: "star",
                    iconColor: Color.orange,
                    title: "Learning Streak",
                    value: "7 Days",
                    subtitle: "Longest: 10 days"
                )

                StatCard(
                    icon: "person.2",
                    iconColor: Color.accentPurple,
                    title: "Next Session",
                    value: "Tomorrow",
                    subtitle: "3:00 PM"
                )
            }
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    let subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(iconColor)

            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)

            Text(value)
                .font(.headline)
                .fontWeight(.bold)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Action Buttons Section
struct ActionButtonsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Word Management")
                .font(.title3)
                .fontWeight(.semibold)

            VStack(spacing: 12) {
                // Add Words Button
                NavigationLink(destination: WordInputView()) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.accentPurple.opacity(0.15))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color.accentPurple)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Add Words")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Create custom lists or select curated packs")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(16)
                }
                .buttonStyle(.plain)
                
                // View All Lists Button
                NavigationLink(destination: WordListsView()) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.accentPurple.opacity(0.15))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "list.bullet.clipboard.fill")
                                .font(.title2)
                                .foregroundColor(Color.accentPurple)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("View All Lists")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Browse and manage your word lists")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(16)
                }
                .buttonStyle(.plain)
                
                // Start Learning Session Button
                Button(action: {}) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.accentPurple)
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "play.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Start Learning Session")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Begin an interactive learning session")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(16)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Recent Activity Section
struct RecentActivitySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activity")
                .font(.title3)
                .fontWeight(.semibold)

            VStack(spacing: 0) {
                ActivityItem(
                    time: "Just now",
                    description: "Lily completed a session, learned 'Ephemeral'!",
                    tags: [
                        ActivityTag(text: "Ephemeral", color: .gray),
                        ActivityTag(text: "Ubiquitous", color: .orange)
                    ],
                    badge: "Session"
                )

                Divider()
                    .padding(.vertical, 8)

                ActivityItem(
                    time: "1 hour ago",
                    description: "Max mastered 'Serendipity'!",
                    tags: [
                        ActivityTag(text: "Serendipity", color: .gray)
                    ],
                    badge: nil
                )

                Divider()
                    .padding(.vertical, 8)

                ActivityItem(
                    time: "3 hours ago",
                    description: "Chloe is struggling with 'Pernicious'.",
                    tags: [
                        ActivityTag(text: "Pernicious", color: .red)
                    ],
                    badge: nil
                )

                Divider()
                    .padding(.vertical, 8)

                ActivityItem(
                    time: "Yesterday",
                    description: "Lily completed a session, learned 'Benevolent'!",
                    tags: [
                        ActivityTag(text: "Benevolent", color: .gray)
                    ],
                    badge: "Session"
                )
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
        }
    }
}

// MARK: - Activity Tag Model
struct ActivityTag {
    let text: String
    let color: Color
}

// MARK: - Activity Item
struct ActivityItem: View {
    let time: String
    let description: String
    let tags: [ActivityTag]
    let badge: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(time)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                if let badge = badge {
                    Text(badge)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.accentPurple)
                        .cornerRadius(12)
                }
            }

            Text(description)
                .font(.subheadline)

            HStack(spacing: 8) {
                ForEach(tags.indices, id: \.self) { index in
                    HStack(spacing: 4) {
                        Image(systemName: tags[index].color == .red ? "xmark.circle" : "person")
                            .font(.caption2)
                        Text(tags[index].text)
                            .font(.caption)
                    }
                    .foregroundColor(tags[index].color == .red ? .red : tags[index].color == .orange ? .orange : .secondary)
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}
