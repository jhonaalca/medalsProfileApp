//
//  PointsEngine.swift
//  MedalsProfileApp
//
//  Created by Jhona Alca on 16/10/25.
//

import Foundation

actor PointsEngine {
    private let repository: MedalRepository
    private var isRunning = false
    private var task: Task<Void, Never>?
    
    init(repository: MedalRepository) {
        self.repository = repository
    }
    
    func start() async {
        guard !isRunning else { return }
        isRunning = true
        
        NotificationCenter.default.post(name: .pointsEngineStarted, object: nil)
        
        task = Task {
            while !Task.isCancelled && isRunning {
                await distributePoints()
                try? await Task.sleep(nanoseconds: AppConstants.pointsUpdateInterval) // 1.5 segundos
            }
        }
    }
    
    func pause() {
        isRunning = false
        task?.cancel()
        task = nil
        
        // Notificar que el motor se ha pausado
        NotificationCenter.default.post(name: .pointsEnginePaused, object: nil)
    }
    
    func distributePoints() async {
        do {
            var medals = try await repository.getAllMedals()
            var leveledUpMedals: [String] = []
            
            for index in medals.indices {
                guard !medals[index].isLocked && !medals[index].isMaxLevel else { continue }
                
                // Puntos aleatorios basados en la rareza
                let pointsToAdd = calculatePointsBasedOnRarity(medals[index].rarity)
                let leveledUp = medals[index].addPoints(pointsToAdd)
                
                if leveledUp {
                    leveledUpMedals.append(medals[index].id)
                }
                
                try await repository.updateMedal(medals[index])
            }
            
            // Notificar level ups
            if !leveledUpMedals.isEmpty {
                await MainActor.run {
                    for medalId in leveledUpMedals {
                        NotificationCenter.default.post(
                            name: .medalLevelUp,
                            object: medalId
                        )
                    }
                }
            }
        } catch {
            print("Error distributing points: \(error)")
        }
    }
    
    private func calculatePointsBasedOnRarity(_ rarity: MedalRarity) -> Int {
            switch rarity {
            case .common:
                return Int.random(in: AppConstants.pointsRangeCommon)
            case .rare:
                return Int.random(in: AppConstants.pointsRangeRare)
            case .epic:
                return Int.random(in: AppConstants.pointsRangeEpic)
            case .legendary:
                return Int.random(in: AppConstants.pointsRangeLegendary)
            }
        }
        
        deinit {
            pause()
        }
}
