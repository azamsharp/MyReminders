//
//  ReminderStatsView.swift
//  RemindersApp
//
//  Created by Mohammad Azam on 1/26/23.
//

import SwiftUI

struct ReminderStatsView: View {
    
    let icon: String
    let title: String
    var count: Int
    
    var body: some View {
        GroupBox {
            HStack {
                VStack(spacing: 10) {
                    Image(systemName: icon)
                    Text(title)
                }
                Spacer()
                Text("\(count)")
                    .font(.largeTitle)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ReminderStatsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ReminderStatsView(icon: "calendar", title: "Today", count: 9)
            ReminderStatsView(icon: "calendar", title: "Today", count: 9)
                .environment(\.colorScheme, .dark)
        }
    }
}
