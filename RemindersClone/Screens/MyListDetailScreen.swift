//
//  MyListDetailScreen.swift
//  RemindersClone
//
//  Created by Mohammad Azam on 4/20/24.
//

import SwiftUI
import SwiftData

struct MyListDetailScreen: View {
    
    let myList: MyList
    @Query private var reminders: [Reminder]
    
    @State private var isOpenAddReminderPresented: Bool = false
    @State private var title: String = ""
    
    @Environment(\.modelContext) private var context
    
    private let delay = Delay()
    
    init(myList: MyList) {
        
        self.myList = myList
        
        let listId = myList.persistentModelID

        // only show the reminders that are not completed
        let predicate = #Predicate<Reminder> { reminder in
            reminder.list?.persistentModelID == listId
            && !reminder.isCompleted
        }
        
        _reminders = Query(filter: predicate)
    }
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }
    
    private func saveReminder() {
        let reminder = Reminder(title: title)
        myList.reminders.append(reminder)
    }
    
    var body: some View {
        VStack {
            
            ReminderListView(reminders: reminders)
            
            Spacer()
            Button(action: {
                isOpenAddReminderPresented = true
            }, label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("New Reminder")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            })
        }
        
        .navigationTitle(myList.name)
            .alert("New Reminder", isPresented: $isOpenAddReminderPresented) {
                TextField("", text: $title)
                Button("Cancel", role: .cancel) { }
                Button("Done") {
                    if isFormValid {
                        saveReminder()
                    }
                }
            }  
    }
}

struct MyListDetailScreenContainer: View {
    
    @Query private var myLists: [MyList]
    
    var body: some View {
        MyListDetailScreen(myList: myLists[0])
    }
}

#Preview { @MainActor in
    NavigationStack {
        MyListDetailScreenContainer()
    }.modelContainer(previewContainer)
}
