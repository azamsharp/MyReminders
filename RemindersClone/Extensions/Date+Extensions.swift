//
//  Date+Extensions.swift
//  RemindersClone
//
//  Created by Mohammad Azam on 5/24/24.
//

import Foundation

extension Date {
    
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
    
    var isTomorrow: Bool {
        let calendar = Calendar.current
        return calendar.isDateInTomorrow(self)
    }
    
}
