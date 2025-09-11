//
//  Enum.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

/// Espécies

public enum Species: Int, Codable {
    case cat = 1
    case dog = 2
    case bear = 3
    case pig = 4
    
    static func random() -> Species {
        let randomValue = Int.random(in: 1...4)
        return Species(rawValue: randomValue)!
    }
}

/// Partes do corpo

public enum BodyPart: Int, Codable {
    case head = 1
    case rightArm = 2
    case leftArm = 3
    case legs = 4
    case tail = 5
}

/// Raridade

public enum rarity: Int, Codable {
    case common = 1
    case rare = 2
    case epic = 3
    case legendary = 4
}

