//
//  MyListsScreen.swift
//  RemindersClone
//
//  Created by Mohammad Azam on 4/20/24.
//

import SwiftUI
import SwiftData

struct MyListsScreen: View {
    
    @Query private var myLists: [MyList]
    @State private var isPresented: Bool = false
    
    @Environment(\.modelContext) private var context
    
    @State private var selectedMyList: MyList?
    
    private func deleteMyList(_ indexSet: IndexSet) {
        guard let index = indexSet.last else { return }
        let myList = myLists[index]
        context.delete(myList)
    }
    
    var body: some View {
        List {
            
            ForEach(myLists) { myList in
                
                NavigationLink(value: myList) {
                    MyListCellView(myList: myList)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedMyList = myList
                        }
                        .onLongPressGesture(minimumDuration: 0.5) {
                            print("LongPress Gesture")
                        }
                        
                }
                
            }.onDelete(perform: deleteMyList)
            
            Button(action: {
                isPresented = true
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
            .sheet(isPresented: $isPresented, content: {
                NavigationStack {
                    AddMyListScreen()
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


