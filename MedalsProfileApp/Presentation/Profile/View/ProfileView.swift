//
//  ProfileView.swift
//  MedalsProfileApp
//
//  Created by Jhona Alca on 16/10/25.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @Environment(\.scenePhase) private var scenePhase
    
    init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header del perfil
                    ProfileHeaderView(
                        userProfile: viewModel.userProfile,
                        isPointsEngineRunning: viewModel.isPointsEngineRunning,
                        onAvatarTap: viewModel.onAvatarTap
                    )
                    
                    // Selector de categorías
                    CategoryFilterView(
                        categories: viewModel.categories,
                        selectedCategory: viewModel.selectedCategory,
                        onSelectCategory: viewModel.selectCategory
                    )
                    
                    // Módulo de Medallas
                    MedalsGridView(
                        medals: viewModel.filteredMedals,
                        isLoading: viewModel.isLoading
                    )
                    
                    // Placeholders para otros módulos
                    MissionsPlaceholderView()
                    StreaksPlaceholderView()
                    AlbumPlaceholderView()
                }
                .padding()
            }
            .navigationTitle("Perfil del Apostador")
            .overlay {
                if viewModel.showLevelUpAnimation, let medal = viewModel.leveledUpMedal {
                    LevelUpAnimationView(medal: medal, animationType: medal.animationType)
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
        .onChange(of: scenePhase) { phase in
            viewModel.handleScenePhaseChange(phase)
        }
    }
}

// Componente de Filtro por Categoría
struct CategoryFilterView: View {
    let categories: [String]
    let selectedCategory: String
    let onSelectCategory: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    CategoryChip(
                        title: category,
                        isSelected: selectedCategory == category,
                        action: { onSelectCategory(category) }
                    )
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

// Vista de Grid de Medallas
struct MedalsGridView: View {
    let medals: [Medal]
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🏅 Mis Medallas")
                .font(.title2)
                .fontWeight(.bold)
            
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if medals.isEmpty {
                EmptyMedalsView()
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    ForEach(medals) { medal in
                        MedalCardView(medal: medal)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

// Tarjeta de Medalla
struct MedalCardView: View {
    let medal: Medal
    
    var body: some View {
        VStack(spacing: 12) {
            // Header de la medalla
            MedalHeaderView(medal: medal)
            
            // Información de progreso
            MedalProgressView(medal: medal)
            
            // Meta del siguiente nivel
            if !medal.isLocked && !medal.isMaxLevel {
                Text(medal.nextLevelGoal)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 2)
        )
        .opacity(medal.isLocked ? 0.6 : 1.0)
    }
    
    private var borderColor: Color {
        if medal.isLocked {
            return .gray
        }
        return Color(hex: medal.rarity.color)
    }
}

// Componente de Header de Medalla
struct MedalHeaderView: View {
    let medal: Medal
    
    var body: some View {
        VStack(spacing: 8) {
            // Icono y rareza
            ZStack(alignment: .topTrailing) {
                Image(systemName: medal.rarity.icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: medal.rarity.color))
                
                if medal.isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                        .padding(4)
                        .background(Color.white)
                        .clipShape(Circle())
                        .offset(x: 4, y: -4)
                }
            }
            
            // Nombre y categoría
            VStack(spacing: 4) {
                Text(medal.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(medal.category)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// Componente de Progreso de Medalla
struct MedalProgressView: View {
    let medal: Medal
    
    var body: some View {
        VStack(spacing: 6) {
            // Nivel y puntos
            HStack {
                Text("Nvl \(medal.level)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(levelColor)
                    .cornerRadius(6)
                
                Spacer()
                
                if !medal.isLocked {
                    Text("\(medal.points)/100")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
            }
            
            // Barra de progreso
            if !medal.isLocked {
                if medal.isMaxLevel {
                    Text("Nivel Máximo")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                } else {
                    ProgressView(value: medal.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: medal.progressColor)))
                        .frame(height: 6)
                }
            } else {
                Text("Bloqueada")
                    .font(.caption2)
                    .foregroundColor(.red)
                    .fontWeight(.medium)
            }
            
            // Recompensa
            if !medal.isLocked {
                Text(medal.reward)
                    .font(.caption2)
                    .foregroundColor(.orange)
                    .fontWeight(.medium)
            }
        }
    }
    
    private var levelColor: Color {
        if medal.isLocked {
            return .gray
        } else if medal.isMaxLevel {
            return .gold
        }
        return Color(hex: medal.progressColor)
    }
}

// Vista para medallas vacías
struct EmptyMedalsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "medal")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("No hay medallas en esta categoría")
                .font(.body)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

// Componente de Header del Perfil
struct ProfileHeaderView: View {
    let userProfile: UserProfile
    let isPointsEngineRunning: Bool
    let onAvatarTap: () -> Void
    
    var body: some View {
            VStack(spacing: 16) {
                // Avatar con indicador de estado
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: userProfile.avatar)
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                        .onTapGesture {
                            onAvatarTap()
                        }
                    
                    // Indicador del motor de puntos
                    Circle()
                        .fill(isPointsEngineRunning ? Color.green : Color.red)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                
                VStack(spacing: 8) {
                    Text(userProfile.username)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 16) {
                        Label("\(userProfile.totalCoins) monedas", systemImage: "dollarsign.circle.fill")
                            .font(.caption)
                        
                        Label("Racha: \(userProfile.currentStreak)d", systemImage: "flame.fill")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                    
                    Text("Miembro desde \(userProfile.joinDate, formatter: dateFormatter)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
        }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct MissionsPlaceholderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🎯 Misiones")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Próximamente...")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct StreaksPlaceholderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🔥 Rachas")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Próximamente...")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct AlbumPlaceholderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📸 Álbum")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Próximamente...")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
