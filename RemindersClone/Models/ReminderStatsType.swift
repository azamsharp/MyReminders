//
//  ReminderStatsType.swift
//  RemindersClone
//
//  Created by Mohammad Azam on 6/8/24.
//

import Foundation

enum ReminderStatsType: Int, Identifiable {
    
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
