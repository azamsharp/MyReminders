//
//  ReminderEditScreen.swift
//  RemindersClone
//
//  Created by Mohammad Azam on 5/6/24.
//

import SwiftUI
import SwiftData

struct ReminderEditScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    var reminder: Reminder
    
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var reminderDate: Date = .now
    @State private var reminderTime: Date = .now
    
    @State private var showCalender: Bool = false
    @State private var showTime: Bool = false
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }
    
    private func updateReminder() {
        reminder.title = title
        reminder.notes = notes
        reminder.reminderDate = showCalender ? reminderDate: nil
        print(reminder.reminderDate) 
        reminder.reminderTime = showTime ? reminderTime: nil
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $title)
                TextField("Notes", text: $notes)
            }
            
            Section {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.red)
                        .font(.title2)
                    Toggle(isOn: $showCalender) {
                        EmptyView()
                    }
                }
                
                if showCalender {
                    HStack {
                        DatePicker("Select Date", selection: $reminderDate, displayedComponents: .date)
                    }
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundStyle(.blue)
                        .font(.title2)
                    Toggle(isOn: $showTime) {
                        EmptyView()
                    }
                }
                
                if showTime {
                    HStack {
                        DatePicker("Select Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    }
                }
            }
            
        }.onAppear(perform: {
            title = reminder.title
            notes = reminder.notes ?? ""
            print(reminder.reminderDate)
            reminderDate = reminder.reminderDate ?? Date()
            reminderTime = reminder.reminderTime ?? Date()
            showCalender = reminder.reminderDate != nil
            showTime = reminder.reminderTime != nil
        })
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    updateReminder()
                    dismiss()
                }.disabled(!isFormValid)
            }
        }
    }
}

struct ReminderEditScreenContainer: View {
    
    @Query private var reminders: [Reminder]
    
    var body: some View {
        ReminderEditScreen(reminder: reminders[0])
    }
}

#Preview {
    NavigationStack {
        ReminderEditScreenContainer()
    }.modelContainer(previewContainer)
}
