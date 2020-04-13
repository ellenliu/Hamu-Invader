//
//  GameOverView.swift
//  Hamu Invaders
//
//  Created by Ellen Liu on 2020-04-08.
//  Copyright © 2020 Ellen Liu. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    override init(size: CGSize) {
        super.init(size: size)
        
        let label = SKLabelNode(fontNamed: "Minecraftia")
        label.text = "You Lose"
        label.fontSize = 50
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width/2, y: size.height/2 + 50)
        addChild(label)
        
        let image = UIImage(named: "you-lose")
        let texture = SKTexture(image: image!)
        let icon = SKSpriteNode(texture: texture)
        icon.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
        addChild(icon)
   }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

