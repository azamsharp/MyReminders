//
//  Array+Extensions.swift
//  RemindersClone
//
//  Created by Mohammad Azam on 6/8/24.
//

import Foundation

// Helper to chunk an array into smaller arrays
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map { Array(self[$0..<Swift.min($0 + size, count)]) }
    }
}
