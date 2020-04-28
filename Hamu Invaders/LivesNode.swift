//
//  LivesNode.swift
//  Hamu Invaders
//
//  Created by Ellen Liu on 2020-04-27.
//  Copyright © 2020 Ellen Liu. All rights reserved.
//

import SpriteKit

class LivesNode: SKNode{ 
    private let livesLabel = SKLabelNode(fontNamed: "Minecraftia")
    private var livesLeft: Int = 3
    private let scoreNode = ScoreNode()
    
    public func setup(_ size: CGSize){
        livesLabel.text = "Lives Left: \(livesLeft)"
        livesLabel.fontSize = 15
        livesLabel.fontColor = SKColor.red
        livesLabel.position = CGPoint(x: 70 , y: size.height - 50)
        addChild(livesLabel)
    }
    
    /**
     Check if the number of lives has gone to zero, if so, transition to the game over scene
     */
    func deductLives(_ gameScene: GameScene, _ size: CGSize) {
        livesLeft -= 1
        self.livesLabel.text = "Lives Left: \(self.livesLeft)"
        if livesLeft == 0 {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: size)
            scoreNode.compareMaxPoints()
            if let maxPoints = UserDefaults.standard.string(forKey: "maxPoints") {
                gameOverScene.maxPoints = Int(maxPoints) ?? -1
            }
            gameOverScene.points = scoreNode.getPoints()
            gameScene.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
}
