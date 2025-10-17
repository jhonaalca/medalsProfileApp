//
//  MedalEntity.swift
//  MedalsProfileApp
//
//  Created by Jhona Alca on 16/10/25.
//

import Foundation
import SwiftData

@Model
final class MedalEntity {
    @Attribute(.unique) var id: String
    var name: String
    var desc: String
    var icon: String
    var category: String
    var rarity: String
    var backgroundColor: String
    var progressColor: String
    
    var level: Int
    var points: Int
    var maxLevel: Int
    var reward: String
    var unlockedAt: String
    var nextLevelGoal: String
    var isLocked: Bool
    var animationType: String
    var lastUpdate: Date?
    
    init(id: String, name: String, description: String, icon: String, category: String, rarity: String, backgroundColor: String, progressColor: String, level: Int, points: Int, maxLevel: Int, reward: String, unlockedAt: String, nextLevelGoal: String, isLocked: Bool, animationType: String, lastUpdate: Date?) {
        self.id = id
        self.name = name
        self.desc = description
        self.icon = icon
        self.category = category
        self.rarity = rarity
        self.backgroundColor = backgroundColor
        self.progressColor = progressColor
        self.level = level
        self.points = points
        self.maxLevel = maxLevel
        self.reward = reward
        self.unlockedAt = unlockedAt
        self.nextLevelGoal = nextLevelGoal
        self.isLocked = isLocked
        self.animationType = animationType
        self.lastUpdate = lastUpdate
    }
    
    convenience init(from domain: Medal) {
        self.init(
            id: domain.id,
            name: domain.name,
            description: domain.description,
            icon: domain.icon,
            category: domain.category,
            rarity: domain.rarity.rawValue,
            backgroundColor: domain.backgroundColor,
            progressColor: domain.progressColor,
            level: domain.level,
            points: domain.points,
            maxLevel: domain.maxLevel,
            reward: domain.reward,
            unlockedAt: domain.unlockedAt,
            nextLevelGoal: domain.nextLevelGoal,
            isLocked: domain.isLocked,
            animationType: domain.animationType.rawValue,
            lastUpdate: domain.lastUpdate
        )
    }
    
    func update(from domain: Medal) {
        self.level = domain.level
        self.points = domain.points
        self.isLocked = domain.isLocked
        self.lastUpdate = domain.lastUpdate
    }
    
    func toDomain() -> Medal {
        Medal(
            id: id,
            name: name,
            description: desc,
            icon: icon,
            category: category,
            rarity: MedalRarity(rawValue: rarity) ?? .common,
            backgroundColor: backgroundColor,
            progressColor: progressColor,
            level: level,
            points: points,
            maxLevel: maxLevel,
            reward: reward,
            unlockedAt: unlockedAt,
            nextLevelGoal: nextLevelGoal,
            isLocked: isLocked,
            animationType: AnimationType(rawValue: animationType) ?? .sparkle,
            lastUpdate: lastUpdate
        )
    }
}
