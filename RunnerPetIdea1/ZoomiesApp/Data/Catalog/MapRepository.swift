//
//  MapRepository.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//

//import Foundation
//
//struct MapDef: Codable {
//    let id: String;
//    let name: String;
//    let dotKmTargets: [Double];
//    let backgroundAsset: String;
//    let petBackgroundAsset: String
//}
//
//final class MapRepository {
//    func all() -> [MapDef] { load("MapDefinitions") }
//    func byId(_ id: String) -> MapDef? { all().first { $0.id == id } }
//
//    private func load<T: Decodable>(_ name: String) -> T {
//        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
//              let data = try? Data(contentsOf: url),
//              let obj = try? JSONDecoder().decode(T.self, from: data) else {
//            fatalError("Failed to load \(name).json from bundle")
//        }
//        return obj
//    }
//}
