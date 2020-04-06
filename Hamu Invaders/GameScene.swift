//
//  GameScene.swift
//  Hamu Invaders
//
//  Created by Ellen Liu on 2020-04-05.
//  Copyright © 2020 Ellen Liu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let hamster = SKSpriteNode(imageNamed: "180")
    
    override func didMove(to view: SKView) {
        hamster.position =  CGPoint(x: size.width * 0.9, y: size.height * 0.5)
        self.addChild(hamster)
    }
}
