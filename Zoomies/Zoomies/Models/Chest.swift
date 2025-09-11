//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
public class Chest {
    @Attribute(.unique) public var id: UUID
    var items: [Item]
    var coinPrice: Int
    var gemPrice: Int
    var isOpened: Bool

    init(id: UUID = UUID(), items: [Item], coinPrice: Int, gemPrice: Int, isOpened: Bool = false) {
        self.id = id
        self.items = items
        self.coinPrice = coinPrice
        self.gemPrice = gemPrice
        self.isOpened = isOpened
    }
}



/// Método de sortear item
