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
    var maxHamstersFedlabel: SKLabelNode!
    var points:Int = -1 {
        didSet{
            hamstersFedlabel.text = "Hamsters  Fed: \(points)"
        }
    }
    var maxPoints:Int = -1 {
        didSet{
            maxHamstersFedlabel.text = "Max  Hamsters  Fed: \(maxPoints)"
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
        hamstersFedlabel.position = CGPoint(x: size.width/2, y: size.height/2 - 10)
        addChild(hamstersFedlabel)
        
        maxHamstersFedlabel = SKLabelNode(fontNamed: "Minecraftia")
        maxHamstersFedlabel.text = "Max  Hamsters  Fed: \(maxPoints)"
        maxHamstersFedlabel.fontSize = 20
        maxHamstersFedlabel.fontColor = SKColor.white
        maxHamstersFedlabel.position = CGPoint(x: size.width/2, y: size.height/2 - 50)
        addChild(maxHamstersFedlabel)
        
//        let image = UIImage(named: "you-lose")
//        let texture = SKTexture(image: image!)
//        let icon = SKSpriteNode(texture: texture)
//        icon.position = CGPoint(x: size.width/2, y: size.height/2 - 150)
//        addChild(icon)
        
        let button = SKSpriteNode(imageNamed: "play-again")
        button.position = CGPoint(x: size.width/2, y: size.height/2 - 120)
        button.name = "playAgain"
        addChild(button)
    }
    
    /**
     Play again, go back to the game scene. 
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
          return
        }
        let touchLocation = touch.location(in: self)
        let nodeArray = nodes(at: touchLocation)
        
        for node in nodeArray{
            if node.name == "playAgain" {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: reveal)
            }
        }
    }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

