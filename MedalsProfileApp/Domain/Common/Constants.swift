//
//  Constants.swift
//  MedalsProfileApp
//
//  Created by Jhona Alca on 17/10/25.
//

import Foundation
enum AppConstants {
    static let pointsUpdateInterval: UInt64 = 1_500_000_000 // 1.5 segundos
    static let pointsRangeCommon = 1...5
    static let pointsRangeRare = 3...8
    static let pointsRangeEpic = 5...12
    static let pointsRangeLegendary = 8...15
    static let pointsPerLevel = 100
    static let resetTapCount = 5
    static let resetTapTimeWindow: TimeInterval = 2.0
}
