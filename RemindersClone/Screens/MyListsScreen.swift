//
//  MyListsScreen.swift
//  RemindersClone
//
//  Created by Mohammad Azam on 4/20/24.
//

import SwiftUI
import SwiftData

struct ReminderStatsData {
    let icon: String
    let title: String
    let count: Int
    let type: ReminderStatsType
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
    
    private var reminderStatsData: [ReminderStatsData] {
        [
            ReminderStatsData(icon: ReminderStatsType.today.icon, title: ReminderStatsType.today.title, count: todaysReminders.count, type: .today),
            ReminderStatsData(icon: ReminderStatsType.scheduled.icon, title: ReminderStatsType.scheduled.title, count: scheduledReminders.count, type: .scheduled),
            ReminderStatsData(icon: ReminderStatsType.all.icon, title: ReminderStatsType.all.title, count: inCompleteReminders.count, type: .all),
            ReminderStatsData(icon: ReminderStatsType.completed.icon, title: ReminderStatsType.completed.title, count: completedReminders.count, type: .completed)
        ]
    }
    
    private func reminders(for type: ReminderStatsType) -> [Reminder] {
        switch type {
            case .all:
                return inCompleteReminders
            case .scheduled:
                return scheduledReminders
            case .today:
                return todaysReminders
            case .completed:
                return completedReminders
        }
    }
 
    var body: some View {
        
        List {
            
            VStack {
                ForEach(Array(reminderStatsData.chunked(into: 2).enumerated()), id: \.offset) { _, chunk in
                    HStack {
                        ForEach(chunk, id: \.title) { data in
                            ReminderStatsView(icon: data.icon, title: data.title, count: data.count)
                                .onTapGesture {
                                    reminderStatsType = data.type
                                }
                        }
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
                ReminderListView(reminders: reminders(for: reminderStatsType))
                            .navigationTitle(reminderStatsType.title)
            }
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


