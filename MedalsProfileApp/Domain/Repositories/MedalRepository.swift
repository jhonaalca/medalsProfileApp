//
//  MedalRepository.swift
//  MedalsProfileApp
//
//  Created by Jhona Alca on 16/10/25.
//

import Foundation

protocol MedalRepository {
    func getAllMedals() async throws -> [Medal]
    func updateMedal(_ medal: Medal) async throws
    func resetAllMedals() async throws
    func saveMedals(_ medals: [Medal]) async throws
    func unlockMedal(_ medalId: String) async throws
}
