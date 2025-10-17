//
//  DefaultMedalRepository.swift
//  MedalsProfileApp
//
//  Created by Jhona Alca on 16/10/25.
//

import Foundation
import SwiftData

final class DefaultMedalRepository: MedalRepository {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getAllMedals() async throws -> [Medal] {
        let descriptor = FetchDescriptor<MedalEntity>()
        let entities = try modelContext.fetch(descriptor)
        
        if entities.isEmpty {
            let defaultMedals = createDefaultMedals()
            try await saveMedals(defaultMedals)
            return defaultMedals
        }
        
        return entities.map { $0.toDomain() }
    }
    
    func updateMedal(_ medal: Medal) async throws {
        let descriptor = FetchDescriptor<MedalEntity>(
            predicate: #Predicate { $0.id == medal.id }
        )
        
        if let entity = try modelContext.fetch(descriptor).first {
            entity.update(from: medal)
            try modelContext.save()
        }
    }
    
    func unlockMedal(_ medalId: String) async throws {
        let descriptor = FetchDescriptor<MedalEntity>(
            predicate: #Predicate { $0.id == medalId }
        )
        
        if let entity = try modelContext.fetch(descriptor).first {
            entity.isLocked = false
            try modelContext.save()
        }
    }
    
    func resetAllMedals() async throws {
        let descriptor = FetchDescriptor<MedalEntity>()
        let entities = try modelContext.fetch(descriptor)
        
        for entity in entities {
            modelContext.delete(entity)
        }
        
        let defaultMedals = createDefaultMedals()
        try await saveMedals(defaultMedals)
    }
    
    func saveMedals(_ medals: [Medal]) async throws {
        for medal in medals {
            let entity = MedalEntity(from: medal)
            modelContext.insert(entity)
        }
        try modelContext.save()
    }
    
// TODO: usar la clase de JSONLoader para hacer la lectura del JSON.
    private func createDefaultMedals() -> [Medal] {
        let jsonData = """
        [
          {
            "id": "m1",
            "name": "Apostador Novato",
            "description": "Alcanza tus primeros 100 puntos en cualquier modalidad.",
            "icon": "medal_novato.png",
            "category": "Progreso",
            "rarity": "Common",
            "backgroundColor": "#E6F4FF",
            "progressColor": "#2196F3",
            "level": 1,
            "points": 45,
            "maxLevel": 5,
            "reward": "10 monedas",
            "unlockedAt": "Registro completado",
            "nextLevelGoal": "Suma 55 puntos más para alcanzar el siguiente nivel.",
            "isLocked": false,
            "animationType": "sparkle"
          },
          {
            "id": "m2",
            "name": "Cazafijas",
            "description": "Gana apuestas consecutivas sin fallar.",
            "icon": "medal_cazafijas.png",
            "category": "Racha",
            "rarity": "Rare",
            "backgroundColor": "#FFF4E6",
            "progressColor": "#FF9800",
            "level": 1,
            "points": 78,
            "maxLevel": 10,
            "reward": "20 monedas",
            "unlockedAt": "3 victorias consecutivas",
            "nextLevelGoal": "Gana 22 puntos más para subir de nivel.",
            "isLocked": false,
            "animationType": "confetti"
          },
          {
            "id": "m3",
            "name": "Capo de las Cuotas",
            "description": "Consigue 10 apuestas con cuota mayor a 3.0.",
            "icon": "medal_capo.png",
            "category": "Desempeño",
            "rarity": "Epic",
            "backgroundColor": "#EDE7F6",
            "progressColor": "#7E57C2",
            "level": 2,
            "points": 20,
            "maxLevel": 8,
            "reward": "Medalla especial",
            "unlockedAt": "Cuotas ganadoras registradas",
            "nextLevelGoal": "Necesitas 80 puntos adicionales.",
            "isLocked": false,
            "animationType": "pulse"
          },
          {
            "id": "m4",
            "name": "Jugador Constante",
            "description": "Ingresa a la app todos los días por una semana.",
            "icon": "medal_constante.png",
            "category": "Actividad",
            "rarity": "Common",
            "backgroundColor": "#F1F8E9",
            "progressColor": "#8BC34A",
            "level": 3,
            "points": 5,
            "maxLevel": 7,
            "reward": "Bonificación diaria",
            "unlockedAt": "7 inicios de sesión consecutivos",
            "nextLevelGoal": "Faltan 95 puntos para subir de nivel.",
            "isLocked": false,
            "animationType": "scalePop"
          },
          {
            "id": "m5",
            "name": "Leyenda del Casino",
            "description": "Juega 50 partidas en el casino online.",
            "icon": "medal_leyenda.png",
            "category": "Casino",
            "rarity": "Legendary",
            "backgroundColor": "#FFFDE7",
            "progressColor": "#FFD600",
            "level": 1,
            "points": 10,
            "maxLevel": 12,
            "reward": "100 monedas + trofeo",
            "unlockedAt": "Participa en el casino",
            "nextLevelGoal": "Juega más para alcanzar el siguiente nivel.",
            "isLocked": false,
            "animationType": "flash"
          },
          {
            "id": "m6",
            "name": "Maestro de la Estrategia",
            "description": "Obtén una racha de 5 apuestas inteligentes.",
            "icon": "medal_estratega.png",
            "category": "Estrategia",
            "rarity": "Epic",
            "backgroundColor": "#E8EAF6",
            "progressColor": "#3F51B5",
            "level": 4,
            "points": 60,
            "maxLevel": 10,
            "reward": "Insignia exclusiva",
            "unlockedAt": "5 estrategias exitosas",
            "nextLevelGoal": "Suma 40 puntos más.",
            "isLocked": false,
            "animationType": "rotate"
          },
          {
            "id": "m7",
            "name": "Coleccionista de Álbum",
            "description": "Completa 5 álbumes de eventos deportivos.",
            "icon": "medal_album.png",
            "category": "Colección",
            "rarity": "Rare",
            "backgroundColor": "#E0F2F1",
            "progressColor": "#009688",
            "level": 1,
            "points": 90,
            "maxLevel": 5,
            "reward": "Sticker especial",
            "unlockedAt": "Primer álbum completado",
            "nextLevelGoal": "Suma 10 puntos más para el siguiente nivel.",
            "isLocked": false,
            "animationType": "shine"
          },
          {
            "id": "m8",
            "name": "Misión Cumplida",
            "description": "Completa 10 misiones semanales.",
            "icon": "medal_mision.png",
            "category": "Misiones",
            "rarity": "Common",
            "backgroundColor": "#FFF3E0",
            "progressColor": "#FB8C00",
            "level": 2,
            "points": 55,
            "maxLevel": 6,
            "reward": "15 monedas",
            "unlockedAt": "Primera misión completada",
            "nextLevelGoal": "Faltan 45 puntos para nivel 3.",
            "isLocked": false,
            "animationType": "bounce"
          },
          {
            "id": "m9",
            "name": "Racha Imparable",
            "description": "Mantén una racha de 7 días ganando.",
            "icon": "medal_racha.png",
            "category": "Racha",
            "rarity": "Epic",
            "backgroundColor": "#FCE4EC",
            "progressColor": "#E91E63",
            "level": 3,
            "points": 98,
            "maxLevel": 10,
            "reward": "50 monedas",
            "unlockedAt": "Racha de 3 días",
            "nextLevelGoal": "Sube 2 puntos más para alcanzar el siguiente nivel.",
            "isLocked": false,
            "animationType": "explosion"
          },
          {
            "id": "m10",
            "name": "Rey del Juego",
            "description": "Alcanza el nivel máximo en todas las medallas.",
            "icon": "medal_rey.png",
            "category": "Leyenda",
            "rarity": "Legendary",
            "backgroundColor": "#FFF8E1",
            "progressColor": "#FFC107",
            "level": 1,
            "points": 0,
            "maxLevel": 15,
            "reward": "Título honorífico + 500 monedas",
            "unlockedAt": "Todas las medallas al menos en nivel 1",
            "nextLevelGoal": "Empieza tu camino hacia el trono.",
            "isLocked": true,
            "animationType": "crownBurst"
          }
        ]
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let medals = try! decoder.decode([Medal].self, from: jsonData)
        return medals.map { medal in
            var updatedMedal = medal
            updatedMedal.lastUpdate = Date()
            return updatedMedal
        }
    }
}
