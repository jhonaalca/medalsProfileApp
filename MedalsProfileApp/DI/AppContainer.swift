//
//  AppContainer.swift
//  MedalsProfileApp
//
//  Created by Jhona Alca on 17/10/25.
//

import Foundation
import SwiftData

@MainActor
final class AppContainer {
    static let shared = AppContainer()
        
        let modelContainer: ModelContainer
        let modelContext: ModelContext
        
        private init() {
            do {
                // Usa el mismo esquema que tu App
                let schema = Schema([
                    MedalEntity.self,
                    // Agrega otros modelos aquí si los tienes
                ])
                let modelConfiguration = ModelConfiguration(
                    schema: schema,
                    isStoredInMemoryOnly: false
                )
                
                modelContainer = try ModelContainer(
                    for: schema,
                    configurations: [modelConfiguration]
                )
                modelContext = ModelContext(modelContainer)
            } catch {
                fatalError("Failed to create ModelContainer: \(error)")
            }
        }
    
    func makeProfileViewModel() -> ProfileViewModel {
        let repository = DefaultMedalRepository(modelContext: modelContext)
        let pointsEngine = PointsEngine(repository: repository)
        let useCases = DefaultMedalUseCases(
            repository: repository,
            pointsEngine: pointsEngine
        )
        
        return ProfileViewModel(
            medalUseCases: useCases,
            pointsEngine: pointsEngine
        )
    }
}
