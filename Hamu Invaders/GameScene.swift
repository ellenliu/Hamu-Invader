//
//  GameScene.swift
//  Hamu Invaders
//
//  Created by Ellen Liu on 2020-04-05.
//  Copyright © 2020 Ellen Liu. All rights reserved.
//

import SpriteKit
import GameplayKit

// Helper functions to do vector math
func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
  func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
  }
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}


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
    
    /**
     When user takes their finger off the screen, we shoot a projectile in the angle where the touch was in these steps
     1. Set up initial location of projectile to where rooster is
     2. Calculate the difference in location between projectile and touch, and make sure touch is not behind rooster
     3. Convert offset to a unit vector and make shoot amount big enough so it def goes off the screen
     4. Create the action to move the projectile
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
          return
        }
        let touchLocation = touch.location(in: self)
        
        let projectile = SKSpriteNode(imageNamed: "sunflower-seed")
        projectile.position = rooster.position
        
        let offset = touchLocation - projectile.position
        if offset.x < 0{
            return
        }
        addChild(projectile)
        
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let destination = shootAmount + projectile.position
        let moveLeft = SKAction.move(to: destination, duration: 2.0)
        let removeFromScreen = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([moveLeft, removeFromScreen]))
    }
}
