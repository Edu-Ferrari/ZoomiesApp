//
//  PetScene.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//


import SpriteKit

final class PetScene: SKScene {
    private let body = SKSpriteNode(imageNamed: "pet/body")
    private let hat  = SKSpriteNode(imageNamed: "pet/none")
    private let suit = SKSpriteNode(imageNamed: "pet/none")

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        body.position = .init(x: size.width/2, y: size.height/2)
        hat.position = body.position
        suit.position = body.position
        addChild(body); addChild(suit); addChild(hat)

        // simple idle motion
        let up = SKAction.moveBy(x: 0, y: 4, duration: 0.8)
        let down = up.reversed()
        body.run(.repeatForever(.sequence([up, down])))
    }

    func apply(_ loadout: Loadout?) {
        guard let l = loadout else { return }
        hat.texture = SKTexture(imageNamed: l.hatId ?? "pet/none")
        suit.texture = SKTexture(imageNamed: l.suitId ?? "pet/none")
    }
}
