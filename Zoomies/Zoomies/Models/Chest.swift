//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import Foundation

public struct Chest {
    var id = UUID()
    var items: [Item]
    var coinPrice : Int
    var gemPrice : Int
}


/// Método de sortear item
