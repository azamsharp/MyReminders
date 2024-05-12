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
    
    var body: some View {
        List {
            /*
            Text("My Lists")
                .font(.largeTitle)
                .bold()
             */
            
            ForEach(myLists) { myList in
                NavigationLink {
                   MyListDetailScreen(myList: myList)
                
                } label: {
                    HStack {
                        Image(systemName: "line.3.horizontal.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(Color(hex: myList.colorCode))
                        Text(myList.name)
                    }
                }
            }
            
            Button(action: {
                isPresented = true
            }, label: {
                Text("Add List")
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }).listRowSeparator(.hidden)
            
        }
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
