//
//  ReminderCellView.swift
//  RemindersClone
//
//  Created by Mohammad Azam on 4/21/24.
//

import SwiftUI
import SwiftData

enum ReminderCellEvents {
    case onChecked(Reminder)
    case onSelect(Reminder)
    case onInfoSelected(Reminder)
}

struct ReminderCellView: View {
    
    let reminder: Reminder
    @State private var checked: Bool = false
    let isSelected: Bool
    let onEvent: (ReminderCellEvents) -> Void
   
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: reminder.isCompleted ? "circle.inset.filled": "circle")
                .font(.title2)
                .onTapGesture {
                    onEvent(.onChecked(reminder))
                }
            VStack(alignment: .leading) {
                Text(reminder.title)
                Text(reminder.notes ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            Spacer()
            Image(systemName: "info.circle.fill")
                .opacity(isSelected ? 1: 0)
                .onTapGesture {
                    onEvent(.onInfoSelected(reminder))
                }
            
        }.contentShape(Rectangle())
            .onTapGesture {
                onEvent(.onSelect(reminder))
            }
    }
}

struct ReminderCellViewContainer: View {
    
    @Query private var reminders: [Reminder]
    
    var body: some View {
        ReminderCellView(reminder: reminders[0], isSelected: false, onEvent: { _ in })
    }
}

#Preview { @MainActor in
   ReminderCellViewContainer()
        .modelContainer(previewContainer)
}
