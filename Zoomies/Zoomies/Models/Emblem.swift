//
//  Emblem.swift
//  Zoomies
//
//  Created by Eduardo Ferrari on 09/09/25.
//

import SwiftUI
import SwiftData

@Model
public class Emblem {
    @Attribute(.unique) public var id: UUID
    var name: String
    var image: Data
    var isFavorite: Bool
    
    init(id: UUID, name: String, image: Data, isFavorite: Bool) {
        self.id = id
        self.name = name
        self.image = image
        self.isFavorite = isFavorite
    }
}
