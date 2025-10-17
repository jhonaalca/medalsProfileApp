//
//  ProfileViewMoel.swift
//  MedalsProfileApp
//
//  Created by Jhona Alca on 16/10/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var medalsByCategory: [String: [Medal]] = [:]
    @Published var userProfile: UserProfile
    @Published var isLoading = false
    @Published var showLevelUpAnimation = false
    @Published var leveledUpMedal: Medal?
    @Published var selectedCategory: String = "Todos"
    @Published var isPointsEngineRunning = false
    
    private let medalUseCases: MedalUseCases
    private let pointsEngine: PointsEngine
    private var cancellables = Set<AnyCancellable>()
    private var tapCount = 0
    private var lastTapTime: Date?
    
    var categories: [String] {
        ["Todos"] + Array(medalsByCategory.keys).sorted()
    }
    
    var filteredMedals: [Medal] {
        if selectedCategory == "Todos" {
            return medalsByCategory.values.flatMap { $0 }
        } else {
            return medalsByCategory[selectedCategory] ?? []
        }
    }
    
    init(medalUseCases: MedalUseCases, pointsEngine: PointsEngine) {
        self.medalUseCases = medalUseCases
        self.pointsEngine = pointsEngine
        self.userProfile = UserProfile(
            username: "Apostador Pro",
            avatar: "person.circle.fill",
            joinDate: Date(),
            totalCoins: 150,
            currentStreak: 5
        )
        
        setupNotifications()
    }
    
    func onAppear() {
        loadMedals()
        startPointsEngine()
    }
    
    private func startPointsEngine() {
           Task {
               await pointsEngine.start()
           }
       }
    
    func onDisappear() {
        pausePointsEngine()
    }
    
    private func pausePointsEngine() {
            Task {
                await pointsEngine.pause()
            }
        }
    
    func handleScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
        case .active:
            startPointsEngine()
        case .background, .inactive:
            pausePointsEngine()
        @unknown default:
            break
        }
    }
    
    func onAvatarTap() {
        let now = Date()
        if let lastTap = lastTapTime, now.timeIntervalSince(lastTap) < AppConstants.resetTapTimeWindow {
            tapCount += 1
        } else {
            tapCount = 1
        }
        
        lastTapTime = now
        
        if tapCount >= AppConstants.resetTapCount {
            resetAllData()
            tapCount = 0
        }
    }
    
    func selectCategory(_ category: String) {
        selectedCategory = category
    }
    
    func unlockMedal(_ medalId: String) async {
        do {
            try await medalUseCases.unlockMedal(medalId)
            await loadMedals()
        } catch {
            print("Error unlocking medal: \(error)")
        }
    }
    
    private func loadMedals() {
        Task {
            isLoading = true
            do {
                medalsByCategory = try await medalUseCases.getMedalsByCategory()
            } catch {
                print("Error loading medals: \(error)")
            }
            isLoading = false
        }
    }
    
    private func resetAllData() {
        Task {
            do {
                try await medalUseCases.resetAllMedals()
                await loadMedals()
                startPointsEngine()
            } catch {
                print("Error resetting data: \(error)")
            }
        }
    }
    
    private func setupNotifications() {
        // Notificación de level up
        NotificationCenter.default.publisher(for: .medalLevelUp)
            .sink { [weak self] notification in
                if let medalId = notification.object as? String {
                    self?.handleLevelUp(medalId)
                }
            }
            .store(in: &cancellables)
        
        // Notificación de motor iniciado
        NotificationCenter.default.publisher(for: .pointsEngineStarted)
            .sink { [weak self] _ in
                self?.isPointsEngineRunning = true
                print("▶️ Points engine started")
            }
            .store(in: &cancellables)
        
        // Notificación de motor pausado
        NotificationCenter.default.publisher(for: .pointsEnginePaused)
            .sink { [weak self] _ in
                self?.isPointsEngineRunning = false
                print("⏸️ Points engine paused")
            }
            .store(in: &cancellables)
    }
    
    private func handleLevelUp(_ medalId: String) {
        Task {
            await loadMedals() // Recargar datos actualizados
            
            // Encontrar la medalla que subió de nivel
            if let medal = filteredMedals.first(where: { $0.id == medalId }) {
                await MainActor.run {
                    leveledUpMedal = medal
                    showLevelUpAnimation = true
                    
                    // Ocultar animación después de 3 segundos
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.showLevelUpAnimation = false
                        self.leveledUpMedal = nil
                    }
                }
            }
        }
    }
}
