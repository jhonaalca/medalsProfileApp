//
//  MedalUseCases.swift
//  MedalsProfileApp
//
//  Created by Jhona Alca on 16/10/25.
//

import Foundation

protocol MedalUseCases {
    func getMedals() async throws -> [Medal]
    func updateMedalProgress() async throws
    func resetAllMedals() async throws
    func unlockMedal(_ medalId: String) async throws
    func getMedalsByCategory() async throws -> [String: [Medal]]
}

final class DefaultMedalUseCases: MedalUseCases {
    private let repository: MedalRepository
    private let pointsEngine: PointsEngine
    
    init(repository: MedalRepository, pointsEngine: PointsEngine) {
        self.repository = repository
        self.pointsEngine = pointsEngine
    }
    
    func getMedals() async throws -> [Medal] {
        try await repository.getAllMedals()
    }
    
    func getMedalsByCategory() async throws -> [String: [Medal]] {
        let medals = try await repository.getAllMedals()
        return Dictionary(grouping: medals) { $0.category }
    }
    
    func updateMedalProgress() async throws {
        try await pointsEngine.distributePoints()
    }
    
    func resetAllMedals() async throws {
        try await repository.resetAllMedals()
    }
    
    func unlockMedal(_ medalId: String) async throws {
        try await repository.unlockMedal(medalId)
    }
}

