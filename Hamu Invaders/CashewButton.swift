//
//  CashewButton.swift
//  Hamu Invaders
//
//  Created by Ellen Liu on 2020-04-27.
//  Copyright © 2020 Ellen Liu. All rights reserved.
//

import SpriteKit
import Foundation

class CashewButton: SKNode {
    private let cashewButton = SKSpriteNode(imageNamed: "cashew")
    private var canPress = true
    
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
        if canPress{
            for node in nodeArray{
                if node.name == "cashewButton" {
                    for child in gameScene.children {
                        if child.name == "hamster" || child.name == "projectile" {
                            child.removeFromParent()
                        }
                    }
                    restrictPress()
                }
            }
        }
    }
    
    /**
     Disable the cashew button
     */
    public func restrictPress(){
        canPress = false
        cashewButton.texture = SKTexture(imageNamed: "cashew-gray")
    }
    
    /**
     Enable the cashew button
     */
    @objc public func allowPress() {
        canPress = true
        cashewButton.texture = SKTexture(imageNamed: "cashew")
    }
}
