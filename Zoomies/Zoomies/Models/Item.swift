//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import Foundation

public struct Item {
    var id = UUID()
    var typeItem: BodyPart
    var isUser: Bool
    var isOwn: Bool
    var coinPrice: Int
    var gemPrice: Int
}
