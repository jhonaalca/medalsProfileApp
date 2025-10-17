//
//  UserProfile.swift
//  MedalsProfileApp
//
//  Created by Jhona Alca on 16/10/25.
//

import Foundation

struct UserProfile: Codable {
    var username: String
    var avatar: String
    var joinDate: Date
    var totalCoins: Int
    var currentStreak: Int
}
