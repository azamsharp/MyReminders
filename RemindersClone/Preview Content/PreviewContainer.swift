//
//  PreviewContainer.swift
//  RemindersClone
//
//  Created by Mohammad Azam on 4/20/24.
//

import Foundation
import SwiftData


@MainActor
var previewContainer: ModelContainer = {
    
    let container = try! ModelContainer(for: MyList.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    for myList in SampleData.myLists {
        container.mainContext.insert(myList)
        myList.reminders = SampleData.Reminders
    }
    
    return container
    
}()

struct SampleData {
    
    static var myLists: [MyList] {
        return [MyList(name: "Reminders", colorCode: "#2ecc71"), MyList(name: "Backlog", colorCode: "#9b59b6")]
    }
    
    static var Reminders: [Reminder] {
        return [Reminder(title: "Reminder 1", reminderDate: Date()), Reminder(title: "Reminder 2", notes: "This is a reminder 2 note", reminderDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()), reminderTime: Date())]
    }
}
