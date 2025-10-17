//
//  Medal.swift
//  MedalsProfileApp
//
//  Created by Jhona Alca on 16/10/25.
//

import Foundation

enum MedalRarity: String, Codable, CaseIterable {
    case common = "Common"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"
    
    var color: String {
        switch self {
        case .common: return "#6B7280"
        case .rare: return "#3B82F6"
        case .epic: return "#8B5CF6"
        case .legendary: return "#F59E0B"
        }
    }
    
    var icon: String {
        switch self {
        case .common: return "medal.fill"
        case .rare: return "star.fill"
        case .epic: return "crown.fill"
        case .legendary: return "flame.fill"
        }
    }
}

enum AnimationType: String, Codable {
    case sparkle, confetti, pulse, scalePop, flash, rotate, shine, bounce, explosion, crownBurst
}

struct Medal: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let category: String
    let rarity: MedalRarity
    let backgroundColor: String
    let progressColor: String
    var level: Int
    var points: Int
    let maxLevel: Int
    let reward: String
    let unlockedAt: String
    let nextLevelGoal: String
    var isLocked: Bool
    let animationType: AnimationType
    var lastUpdate: Date?
    
    var progress: Double {
        Double(points) / Double(AppConstants.pointsPerLevel)
    }
    
    var isMaxLevel: Bool {
        level >= maxLevel
    }
    
    var pointsToNextLevel: Int {
        AppConstants.pointsPerLevel - points
    }
    
    mutating func addPoints(_ pointsToAdd: Int) -> Bool {
        guard !isLocked && !isMaxLevel else { return false }
        
        let oldLevel = level
        points += pointsToAdd
        
        if points >= AppConstants.pointsPerLevel {
            level += 1
            points = 0
            lastUpdate = Date()
            return level > oldLevel
        }
        
        lastUpdate = Date()
        return false
    }
    
    mutating func unlock() {
        isLocked = false
    }
}
