//
//  FooView.swift
//  RemindersClone
//
//  Created by Mohammad Azam on 6/7/24.
//

import SwiftUI

enum StatsType: Int, Identifiable, CaseIterable {
    
    case today
    case scheduled
    case all
    case completed
    
    var id: Int {
        self.rawValue
    }
    
    var title: String {
        switch self {
        case .today:
            return "Today"
        case .scheduled:
            return "Scheduled"
        case .all:
            return "All"
        case .completed:
            return "Completed"
        }
    }
    
    var icon: String {
        switch self {
        case .today:
            return "calendar"
        case .scheduled:
            return "calendar.circle.fill"
        case .all:
            return "tray.circle.fill"
        case .completed:
            return "checkmark.circle.fill"
        }
    }
}

struct StatsView: View {
    
    let stats = StatsType.allCases

    var body: some View {
        Grid {
            ForEach(0..<2) { row in
                GridRow {
                    ForEach(0..<2) { column in
                        let index = row * 2 + column
                        if index < stats.count {
                            GroupBox {
                                HStack {
                                    VStack(spacing: 10) {
                                        Image(systemName: stats[index].icon)
                                        Text(stats[index].title)
                                    }
                                    Spacer()
                                    Text("20")
                                        .font(.largeTitle)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    StatsView()
}
