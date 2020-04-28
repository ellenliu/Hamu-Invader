//
//  CashewButton.swift
//  Hamu Invaders
//
//  Created by Ellen Liu on 2020-04-27.
//  Copyright © 2020 Ellen Liu. All rights reserved.
//

import SpriteKit

class CashewButton: SKNode {
    private let cashewButton = SKSpriteNode(imageNamed: "cashew")
    
    public func setup(_ size: CGSize){
        cashewButton.setScale(1.5)
        cashewButton.position = CGPoint(x: size.width - 60, y: 60)
        cashewButton.name = "cashewButton"
        addChild(cashewButton) 
    }
    
    /**
     Remove all hamsters on screen when button is pressed
     */
    public func removeHamsters(_ nodeArray: [SKNode], _ gameScene: GameScene){
        for node in nodeArray{
            if node.name == "cashewButton" {
                for child in gameScene.children {
                    if child.name == "hamster" || child.name == "projectile" {
                        child.removeFromParent()
                    }
                }
                cashewButton.texture = SKTexture(imageNamed: "cashew-gray") 
            }
        }
    }
    
}
