//
//  ReminderListView.swift
//  RemindersClone
//
//  Created by Mohammad Azam on 6/7/24.
//

import SwiftUI
import SwiftData

struct ReminderListView: View {
    
    let reminders: [Reminder]
    @Environment(\.modelContext) private var context
    
    @Binding var selectedReminder: Reminder?
    @Binding var showReminderEditScreen: Bool
    
    private let delay = Delay()
    
    private func isReminderSelected(_ reminder: Reminder) -> Bool {
        reminder.persistentModelID == selectedReminder?.persistentModelID
    }
    
    private func deleteReminder(_ indexSet: IndexSet) {
        guard let index = indexSet.last else { return }
        let reminder = reminders[index]
        context.delete(reminder)
    }
    
    var body: some View {
        List {
            ForEach(reminders) { reminder in
                ReminderCellView(reminder: reminder, isSelected: isReminderSelected(reminder)) { event in
                    switch event {
                    case .onChecked(let reminder, let checked):
                        // cancel pending tasks
                        delay.cancel()
                        delay.performWork {
                            reminder.isCompleted = checked
                        }
                    case .onSelect(let reminder):
                        selectedReminder = reminder
                    case .onInfoSelected(let reminder):
                        print(reminder.title)
                        selectedReminder = reminder
                        showReminderEditScreen = true
                       
                    }
                }
            }.onDelete(perform: deleteReminder)
        }
    }
}
