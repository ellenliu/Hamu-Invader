//
//  GameOverView.swift
//  Hamu Invaders
//
//  Created by Ellen Liu on 2020-04-08.
//  Copyright © 2020 Ellen Liu. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var hamstersFedlabel: SKLabelNode!
    var points:Int = -1 {
        didSet{
            hamstersFedlabel.text = "Hamsters  Fed: \(points)"
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let label = SKLabelNode(fontNamed: "Minecraftia")
        label.text = "You Lose"
        label.fontSize = 50
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width/2, y: size.height/2 + 50)
        addChild(label)
        
        hamstersFedlabel = SKLabelNode(fontNamed: "Minecraftia")
        hamstersFedlabel.text = "Hamsters  Fed: \(points)"
        hamstersFedlabel.fontSize = 20
        hamstersFedlabel.fontColor = SKColor.white
        hamstersFedlabel.position = CGPoint(x: size.width/2, y: size.height/2 - 30)
        addChild(hamstersFedlabel)
        
        let image = UIImage(named: "you-lose")
        let texture = SKTexture(image: image!)
        let icon = SKSpriteNode(texture: texture)
        icon.position = CGPoint(x: size.width/2, y: size.height/2 - 130)
        addChild(icon)
   }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

