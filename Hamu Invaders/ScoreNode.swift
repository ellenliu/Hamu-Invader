//
//  ScoreNode.swift
//  Hamu Invaders
//
//  Created by Ellen Liu on 2020-04-27.
//  Copyright © 2020 Ellen Liu. All rights reserved.
//

import SpriteKit

class ScoreNode: SKNode{
    let pointsLabel = SKLabelNode(fontNamed: "Minecraftia")
    var hamstersFed:Int = 0
    
    public func setup(_ size: CGSize) {
        pointsLabel.text = "Hamsters Fed: \(hamstersFed)"
        pointsLabel.fontSize = 15
        pointsLabel.fontColor = SKColor.white
        pointsLabel.position = CGPoint(x: size.width - 90 , y: size.height - 50)
        addChild(pointsLabel)
    }
    
    public func addPoint(){
        hamstersFed += 1
        pointsLabel.text = "Hamsters Fed: \(hamstersFed)"
    }
    
    public func getPoints() -> Int{
        return hamstersFed
    }
    
    /**
     Compare if the user's points this turn is the max points, and update UserDefault if so
     */
    public func compareMaxPoints(){
        if let currMax = UserDefaults.standard.string(forKey: "maxPoints") {
            if hamstersFed > Int(currMax) ?? 0 {
                UserDefaults.standard.set(hamstersFed, forKey: "maxPoints")
            }
        }
    }
}
