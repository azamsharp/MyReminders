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
    
    @Environment(\.modelContext) private var context
    @State private var selectedMyList: MyList?
    
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
    
    @State private var actionSheet: MyListScreenSheets?
    
    private func deleteMyList(_ indexSet: IndexSet) {
        guard let index = indexSet.last else { return }
        let myList = myLists[index]
        context.delete(myList)
    }
    
    var body: some View {
        List {
            
            VStack {
                HStack {
                    GroupBox {
                        HStack {
                            VStack(spacing: 10) {
                                Image(systemName: "heart")
                                Text("Today")
                            }
                            
                            Text("0")
                                .font(.largeTitle)
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    GroupBox {
                        HStack {
                            VStack(spacing: 10) {
                                Image(systemName: "heart")
                                Text("Today")
                            }
                            
                            Text("0")
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


