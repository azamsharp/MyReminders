//
//  MyListsScreen.swift
//  RemindersClone
//
//  Created by Mohammad Azam on 4/20/24.
//

import SwiftUI
import SwiftData

enum ReminderFilter {
    
    case today
    case scheduled
    
    static func remindersBy(_ filter: ReminderFilter, _ reminders: [Reminder]) -> [Reminder] {
        
        switch filter {
        case .today:
            return reminders.filter {
                guard let reminderDate = $0.reminderDate else { return false }
                return reminderDate.isToday
            }
        case .scheduled:
            return reminders.filter {
                $0.reminderDate != nil
            }
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
    
    private func deleteMyList(_ indexSet: IndexSet) {
        guard let index = indexSet.last else { return }
        let myList = myLists[index]
        context.delete(myList)
    }
    
    private var reminderCounts: (Int, Int, Int, Int) {
        return (
            ReminderFilter.remindersBy(.today, reminders).count
            , ReminderFilter.remindersBy(.scheduled, reminders).count
            , 4
            , 5
        )
    }
    
    var body: some View {
        
        let (todaysCount, scheduledCount, c, d) = reminderCounts
        
        List {
            
            VStack {
                HStack {
                    GroupBox {
                        HStack {
                            VStack(spacing: 10) {
                                Image(systemName: "heart")
                                Text("Today")
                            }
                            Spacer()
                            Text("\(todaysCount)")
                                .font(.largeTitle)
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    GroupBox {
                        HStack {
                            VStack(spacing: 10) {
                                Image(systemName: "heart")
                                Text("Scheduled")
                            }
                            
                            Text("\(scheduledCount)")
                                .font(.largeTitle)
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                
                HStack {
                    GroupBox {
                        Text("Foo")
                    }
                    GroupBox {
                        Text("Foo")
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


