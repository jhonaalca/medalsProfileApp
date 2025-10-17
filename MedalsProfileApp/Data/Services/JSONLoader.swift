//
//  JSONLoader.swift
//  MedalsProfileApp
//
//  Created by Jhona Alca on 17/10/25.
//

import Foundation

enum JSONLoaderError: Error {
    case fileNotFound
    case invalidData
    case decodingError(Error)
}

final class JSONLoader {
    static func loadMedalsFromJSON() throws -> [Medal] {
        guard let url = Bundle.main.url(forResource: "medals", withExtension: "json") else {
            throw JSONLoaderError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            let medals = try decoder.decode([Medal].self, from: data)
            return medals.map { medal in
                var updatedMedal = medal
                updatedMedal.lastUpdate = Date()
                return updatedMedal
            }
        } catch {
            throw JSONLoaderError.decodingError(error)
        }
    }
    
    static func loadMedalsFromJSONAsync() async throws -> [Medal] {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                do {
                    let medals = try loadMedalsFromJSON()
                    continuation.resume(returning: medals)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
