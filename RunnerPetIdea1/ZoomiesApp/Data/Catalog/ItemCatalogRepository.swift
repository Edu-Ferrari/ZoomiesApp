//
//  ItemCatalogRepository.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//

//import Foundation
//
//struct ItemDef: Codable {
//    let itemId: String
//    let type: String
//    let rarity: String
//    let gemCost: Int
//    let productId: String?
//    let assetName: String
//}
//
//final class ItemCatalogRepository {
//    func all() -> [ItemDef] { load("ItemCatalog") }
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
