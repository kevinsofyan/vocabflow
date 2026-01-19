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
                                colors: [Color.orange.opacity(0.3), Color.pink.opacity(0.3)],
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
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Stats")
                .font(.title3)
                .fontWeight(.semibold)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
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
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Action Buttons Section
struct ActionButtonsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What would you like to do?")
                .font(.title3)
                .fontWeight(.semibold)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ActionButton(
                    icon: "play.circle",
                    title: "Start\nLearning\nSession",
                    isPrimary: true
                ) {}

                ActionButton(
                    icon: "plus",
                    title: "Add Words",
                    isPrimary: false
                ) {}

                ActionButton(
                    icon: "list.bullet.clipboard",
                    title: "View All Lists",
                    isPrimary: false
                ) {}

                ActionButton(
                    icon: "chart.bar",
                    title: "View Progress\nReport",
                    isPrimary: false
                ) {}
            }
        }
    }
}

// MARK: - Action Button
struct ActionButton: View {
    let icon: String
    let title: String
    let isPrimary: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .foregroundColor(isPrimary ? .white : .primary)
            .background(isPrimary ? Color.accentPurple : Color(UIColor.systemBackground))
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
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
