//
//  MyListsScreen.swift
//  RemindersClone
//
//  Created by Mohammad Azam on 4/20/24.
//

import SwiftUI
import SwiftData

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
}

enum MyListScreenSheets: Identifiable {
    case newList
    case editList(MyList)
    
    var id: Int {
        switch self {
        case .newList:
            return 1
        case .editList(_):
            return 2
        }
    }
}

struct MyListsScreen: View {
    
    @Query private var myLists: [MyList]
    @Query private var reminders: [Reminder]
    
    @Environment(\.modelContext) private var context
    @State private var selectedMyList: MyList?
    @State private var actionSheet: MyListScreenSheets?
    
    @State private var reminderStatsType: ReminderStatsType?
    
    private func deleteMyList(_ indexSet: IndexSet) {
        guard let index = indexSet.last else { return }
        let myList = myLists[index]
        context.delete(myList)
    }
    
    private var inCompleteReminders: [Reminder] {
        reminders.filter { !$0.isCompleted }
    }
    
    private var todaysReminders: [Reminder] {
        reminders.filter {
            guard let reminderDate = $0.reminderDate else {
                return false
            }
            
            return reminderDate.isToday && !$0.isCompleted
        }
    }
    
    private var scheduledReminders: [Reminder] {
        reminders.filter {
            $0.reminderDate != nil && !$0.isCompleted
        }
    }
    
    private var completedReminders: [Reminder] {
        reminders.filter { $0.isCompleted }
    }
    
    var body: some View {
        
        List {
            
            VStack {
                HStack {
                    
                    ReminderStatsView(icon: "calendar", title: "Today", count: todaysReminders.count)
                        .onTapGesture {
                            reminderStatsType = .today
                        }
                    
                    ReminderStatsView(icon: "calendar.circle.fill", title: "Scheduled", count: scheduledReminders.count)
                        .onTapGesture {
                            reminderStatsType = .scheduled
                        }
                }
                
                HStack {
                    
                    ReminderStatsView(icon: "tray.circle.fill", title: "All", count: inCompleteReminders.count)
                        .onTapGesture {
                            reminderStatsType = .all
                        }
                    
                    ReminderStatsView(icon: "checkmark.circle.fill", title: "Completed", count: completedReminders.count)
                        .onTapGesture {
                            reminderStatsType = .completed
                        }
                }
            }
            
            ForEach(myLists) { myList in
                
                NavigationLink(value: myList) {
                    MyListCellView(myList: myList)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedMyList = myList
                        }
                        .onLongPressGesture(minimumDuration: 0.5) {
                            actionSheet = .editList(myList)
                        }
                }
                
            }.onDelete(perform: deleteMyList)
            
            Button(action: {
                actionSheet = .newList
            }, label: {
                Text("Add List")
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }).listRowSeparator(.hidden)
            
        }
        .navigationDestination(item: $selectedMyList, destination: { myList in
            MyListDetailScreen(myList: myList)
        })
        
        .navigationDestination(item: $reminderStatsType, destination: { reminderStatsType in
            NavigationStack {
                switch reminderStatsType {
                    case .all:
                        ReminderListView(reminders: inCompleteReminders)
                    case .scheduled:
                        ReminderListView(reminders: scheduledReminders)
                    case .today:
                        ReminderListView(reminders: todaysReminders)
                    case .completed:
                        ReminderListView(reminders: completedReminders)
                }
            }.navigationTitle(reminderStatsType.title)
        })
        
       
        .navigationTitle("My Lists")
        .listStyle(.plain)
        .sheet(item: $actionSheet, content: { actionSheet in
            switch actionSheet {
            case .newList:
                NavigationStack {
                    AddMyListScreen()
                }
            case .editList(let myList):
                NavigationStack {
                    AddMyListScreen(myList: myList)
                }
            }
        })
        .overlay {
            if myLists.isEmpty {
                ContentUnavailableView("No lists are available!", systemImage: "list.bullet")
            }
        }
    }
}

#Preview { @MainActor in
    NavigationStack {
        MyListsScreen()
    }.modelContainer(previewContainer)
}


