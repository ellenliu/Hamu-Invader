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
    
    let rooster = SKSpriteNode(imageNamed: "jooster")
    
    override func didMove(to view: SKView) {
        rooster.position =  CGPoint(x: size.width * 0.2, y: size.height * 0.50)
        rooster.setScale(0.25)
        self.addChild(rooster)
        
        // loop endlessly once a second
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(addHamsters),
            SKAction.wait(forDuration: 1.0)
            ])
        ))
    }
    
    // Helper functions for generating positions
    func random() -> CGFloat {
      return CGFloat(Float(arc4random()) / 4294967296)
    }

    func random(min: CGFloat, max: CGFloat) -> CGFloat {
      return random() * (max - min) + min
    }
    
    /**
     Determine the position to generate hamsters, and create an action for them to move across the screen and be removed
     */
    func addHamsters(){
        let hamster = SKSpriteNode(imageNamed: "hamster")
        let yPos = random(min: hamster.size.height/8, max: size.height - hamster.size.height/8)
        hamster.position = CGPoint(x: size.width + hamster.size.width/8, y: yPos)
        hamster.setScale(0.25)
        self.addChild(hamster)
        
        let speed = random(min: CGFloat(2.0), max: CGFloat(5.0))
        let moveLeft = SKAction.move(to: CGPoint(x: -hamster.size.width/8, y: yPos),
        duration: TimeInterval(speed))
        let removeFromScreen = SKAction.removeFromParent()
        hamster.run(SKAction.sequence([moveLeft, removeFromScreen]))
    }
}
