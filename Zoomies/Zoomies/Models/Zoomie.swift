//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import Foundation
import SwiftData

@Model
public class Zoomie {
    @Attribute(.unique) public var id = UUID()
    var name: String
    var owner: User
    var type: Species
    
    init(name: String, owner: User, type: Species? = nil) {
        self.name = name
        self.owner = owner
        self.type = type ?? Species.random()
    }

}
