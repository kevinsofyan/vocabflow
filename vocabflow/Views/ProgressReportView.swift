//
//  ProgressReportView.swift
//  vocabflow
//
//  Created by Kevin Sofyan on 22/01/26.
//

import SwiftUI

struct ProgressReportView: View {
    @State private var selectedPeriod: TimePeriod = .month
    @State private var selectedTab = 1
    
    enum TimePeriod: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case allTime = "All Time"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Time Period Selector
                        HStack(spacing: 12) {
                            ForEach(TimePeriod.allCases, id: \.self) { period in
                                Button(action: { selectedPeriod = period }) {
                                    Text(period.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(selectedPeriod == period ? .white : .primary)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 8)
                                        .background(selectedPeriod == period ? Color.accentPurple : Color(UIColor.secondarySystemBackground))
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)
                        
                        // Words Mastered Over Time
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Words Mastered Over Time")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text("Track how many words your child has successfully mastered over the past month.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            LineChartView()
                                .frame(height: 180)
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        // Session Completion Rate
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Session Completion Rate")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text("The percentage of learning sessions completed by your child over the past month.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            BarChartView()
                                .frame(height: 180)
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        // Average Session Performance
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Average Session Performance")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text("Average accuracy across spelling and meaning tasks.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            DonutChartView()
                                .frame(height: 200)
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        // Mastery Stage Milestones
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Mastery Stage Milestones")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text("Key indicators of long-term vocabulary retention.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            VStack(spacing: 16) {
                                MilestoneRow(
                                    icon: "medal.fill",
                                    iconColor: .purple,
                                    title: "1-Day Retention",
                                    description: "Excellent: Words recalled after 24 hours."
                                )
                                
                                MilestoneRow(
                                    icon: "checkmark.circle.fill",
                                    iconColor: .cyan,
                                    title: "1-Week Retention",
                                    description: "Good: Consistent recall over a week."
                                )
                                
                                MilestoneRow(
                                    icon: "clock.fill",
                                    iconColor: .orange,
                                    title: "2-Week Reinforcement",
                                    description: "Progressing: Needs occasional review after two weeks."
                                )
                                
                                MilestoneRow(
                                    icon: "clock.fill",
                                    iconColor: .green.opacity(0.6),
                                    title: "1-Month Mastery",
                                    description: "Developing: Long-term recall still in progress."
                                )
                            }
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(16)
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
                }
                
                // Bottom Navigation
                HStack(spacing: 0) {
                    NavigationLink(destination: DashboardView()) {
                        VStack(spacing: 4) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 20))
                            Text("Dashboard")
                                .font(.caption)
                        }
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                    }
                    
                    NavigationLink(destination: WordListsView()) {
                        VStack(spacing: 4) {
                            Image(systemName: "list.bullet.clipboard")
                                .font(.system(size: 20))
                            Text("Lists")
                                .font(.caption)
                        }
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                    }
                    
                    TabButton(icon: "chart.bar", label: "Progress", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                }
                .padding(.vertical, 8)
                .background(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

// MARK: - Line Chart View
struct LineChartView: View {
    let dataPoints: [CGFloat] = [15, 22, 28, 26, 30, 38]
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Chart
            GeometryReader { geometry in
                ZStack {
                    // Grid lines
                    VStack(spacing: 0) {
                        ForEach(0..<4) { i in
                            if i > 0 {
                                Spacer()
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 1)
                            }
                        }
                        Spacer()
                    }
                    
                    // Line path
                    Path { path in
                        let maxValue: CGFloat = 45
                        let stepX = geometry.size.width / CGFloat(dataPoints.count - 1)
                        let stepY = geometry.size.height / maxValue
                        
                        for (index, value) in dataPoints.enumerated() {
                            let x = stepX * CGFloat(index)
                            let y = geometry.size.height - (value * stepY)
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(Color.accentPurple, lineWidth: 2.5)
                    
                    // Data points
                    ForEach(0..<dataPoints.count, id: \.self) { index in
                        let maxValue: CGFloat = 45
                        let stepX = geometry.size.width / CGFloat(dataPoints.count - 1)
                        let stepY = geometry.size.height / maxValue
                        let x = stepX * CGFloat(index)
                        let y = geometry.size.height - (dataPoints[index] * stepY)
                        
                        Circle()
                            .fill(Color.accentPurple)
                            .frame(width: 6, height: 6)
                            .position(x: x, y: y)
                    }
                }
            }
            .frame(height: 120)
            .padding(.vertical, 8)
            
            // X-axis labels
            HStack {
                ForEach(months, id: \.self) { month in
                    Text(month)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Legend
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.accentPurple)
                    .frame(width: 8, height: 8)
                Text("Words Mastered")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

// MARK: - Bar Chart View
struct BarChartView: View {
    let dataPoints: [CGFloat] = [75, 82, 68, 85, 78, 88]
    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: 8) {
            // Chart
            GeometryReader { geometry in
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(0..<dataPoints.count, id: \.self) { index in
                        VStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.cyan)
                                .frame(height: (dataPoints[index] / 105) * geometry.size.height)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .frame(height: 120)
            
            // X-axis labels
            HStack {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Legend
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.cyan)
                    .frame(width: 12, height: 8)
                Text("Completion Rate")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

// MARK: - Donut Chart View
struct DonutChartView: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                // Spelling arc (orange)
                Circle()
                    .trim(from: 0, to: 0.45)
                    .stroke(Color.orange, lineWidth: 25)
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                
                // Meaning arc (green)
                Circle()
                    .trim(from: 0, to: 0.55)
                    .stroke(Color.green.opacity(0.7), lineWidth: 25)
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(90))
            }
            
            // Legend
            HStack(spacing: 24) {
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.orange)
                        .frame(width: 12, height: 8)
                    Text("Spelling")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.green.opacity(0.7))
                        .frame(width: 12, height: 8)
                    Text("Meaning")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

// MARK: - Milestone Row
struct MilestoneRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    ProgressReportView()
}
