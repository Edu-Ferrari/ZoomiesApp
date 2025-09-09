//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import Foundation
import SwiftData

@Model
public class Item {
    @Attribute(.unique) public var id: UUID = UUID()
    var typeItem: BodyPart
    var isUser: Bool
    var isOwn: Bool
    var coinPrice: Int
    var gemPrice: Int

    init(typeItem: BodyPart, isUser: Bool, isOwn: Bool, coinPrice: Int, gemPrice: Int) {
        self.id = UUID()
        self.typeItem = typeItem
        self.isUser = isUser
        self.isOwn = isOwn
        self.coinPrice = coinPrice
        self.gemPrice = gemPrice
    }
}

    
