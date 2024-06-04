//
//  ReminderCellView.swift
//  RemindersClone
//
//  Created by Mohammad Azam on 4/21/24.
//

import SwiftUI
import SwiftData

enum ReminderCellEvents {
    case onChecked(Reminder, Bool)
    case onSelect(Reminder)
    case onInfoSelected(Reminder)
}

struct ReminderCellView: View {
    
    let reminder: Reminder
    @State private var checked: Bool = false
    let isSelected: Bool
    let onEvent: (ReminderCellEvents) -> Void
   
    private func formatReminderDate(_ date: Date) -> String {
        if date.isToday {
            return "Today"
        } else if date.isTomorrow {
            return "Tomorrow"
        } else {
            return date.formatted(date: .numeric, time: .omitted)
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: checked ? "circle.inset.filled": "circle")
                .font(.title2)
                .padding([.trailing], 5)
                .onTapGesture {
                    checked.toggle()
                    onEvent(.onChecked(reminder, checked))
                }
            VStack {
                
                Text(reminder.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                   
                if let notes = reminder.notes {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                   
                HStack {
                    
                    if let reminderDate = reminder.reminderDate {
                        Text(formatReminderDate(reminderDate))
                    }
                    
                    if let reminderTime = reminder.reminderTime {
                        Text(reminderTime.formatted())
                    }
                    
                }.font(.caption)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            }
            Spacer()
            Image(systemName: "info.circle.fill")
                .opacity(isSelected ? 1: 0)
                .onTapGesture {
                    onEvent(.onInfoSelected(reminder))
                }
            
        }
        .onAppear(perform: {
            checked = reminder.isCompleted
        })
        
        .contentShape(Rectangle())
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
