//
//  GameScene.swift
//  Hamu Invaders
//
//  Created by Ellen Liu on 2020-04-05.
//  Copyright © 2020 Ellen Liu. All rights reserved.
//

import SpriteKit
import GameplayKit
import SwiftUI
import Foundation

struct PhysicsCategory {
  static let none      : UInt32 = 0
  static let all       : UInt32 = UInt32.max
  static let hamster   : UInt32 = 0b01
  static let projectile: UInt32 = 0b10
}

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
    
    let jooster = SKSpriteNode(imageNamed: "jooster")
    let looster = SKSpriteNode(imageNamed: "looster")
    let pointsLabel = SKLabelNode(fontNamed: "Minecraftia")
    let livesLabel = SKLabelNode(fontNamed: "Minecraftia")
    var hamstersFed:Int = 0
    var livesLeft: Int = 3
    
    override func didMove(to view: SKView) {
        // user selected which character to display
        if let currCharacter = UserDefaults.standard.string(forKey: "character") {
            if currCharacter == "looster" {
                looster.position = CGPoint(x: size.width * 0.2, y: size.height * 0.50)
                looster.setScale(0.25)
                self.addChild(looster)
            } else {
                jooster.position = CGPoint(x: size.width * 0.2, y: size.height * 0.50)
                jooster.setScale(0.25)
                self.addChild(jooster)
            }
        }
        
        //loop endlessly once a second
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run({self.addHamsters(isHeroHamster: false)}),
            SKAction.wait(forDuration: 2.0, withRange: 2.0)
            ])
        ))
        run(
          SKAction.sequence([
            SKAction.wait(forDuration: 15.0),
            SKAction.run(levelTwo)
            ]
        ))
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        pointsLabel.text = "Hamsters Fed: \(hamstersFed)"
        pointsLabel.fontSize = 15
        pointsLabel.fontColor = SKColor.white
        pointsLabel.position = CGPoint(x: size.width - 90 , y: size.height - 50)
        addChild(pointsLabel)
        
        livesLabel.text = "Lives Left: \(livesLeft)"
        livesLabel.fontSize = 15
        livesLabel.fontColor = SKColor.red
        livesLabel.position = CGPoint(x: 70 , y: size.height - 50)
        addChild(livesLabel)
        
        // Add audio
        let backgroundMusic = SKAudioNode(fileNamed: "Reborn.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    // Helper functions for generating positions
    func random() -> CGFloat {
      return CGFloat(Float(arc4random()) / 4294967296)
    }

    func random(min: CGFloat, max: CGFloat) -> CGFloat {
      return random() * (max - min) + min
    }
    
    /**
     Determine the position to generate regular hamsters, and hero hamsters, creates each physics body, and create an action for them to move across the screen and be removed
     */
    func addHamsters(isHeroHamster: Bool){
        let hamster: SKSpriteNode
        if isHeroHamster {
            hamster = SKSpriteNode(imageNamed: "hero-hamster")
            hamster.setScale(0.75)
        } else {
            hamster = SKSpriteNode(imageNamed: "hamster")
            hamster.setScale(0.25)
        }
        
        hamster.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: hamster.size.width / 4, height: hamster.size.height / 4))
        hamster.physicsBody?.isDynamic = true
        hamster.physicsBody?.categoryBitMask = PhysicsCategory.hamster
        hamster.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // notify when it hits a projectile
        hamster.physicsBody?.collisionBitMask = PhysicsCategory.none // dont bounce off each other
        
        let yPos = random(min: hamster.size.height/8, max: size.height - hamster.size.height/8)
        hamster.position = CGPoint(x: size.width + hamster.size.width/8, y: yPos)
        self.addChild(hamster)
        
        let speed = random(min: CGFloat(2.0), max: CGFloat(5.0))
        let moveLeftSlow = SKAction.move(to: CGPoint(x: size.width/1.3, y: yPos),
                                         duration: TimeInterval(speed * 1.2))
        
        let moveLeftFast = SKAction.move(to: CGPoint(x: -hamster.size.width/8, y: yPos),
                                     duration: TimeInterval(speed / 2))
        
        let moveLeftNormal = SKAction.move(to: CGPoint(x: -hamster.size.width/8, y: yPos),
                                         duration: TimeInterval(speed))
        let removeFromScreen = SKAction.removeFromParent()
        
        // Transition to GameOverScene, passing data
        let deductLives = SKAction.run() {self.deductLives()}
        
        if isHeroHamster {
            hamster.run(SKAction.sequence([moveLeftSlow, moveLeftFast, deductLives, removeFromScreen]))
        } else {
            hamster.run(SKAction.sequence([moveLeftNormal, deductLives, removeFromScreen]))
        }
    }
    
    /**
     Create hungover hamsters that move in a bezier curve, and add physics body
     */
    func addHungoverHamsters(){
        let hungoverHamster = SKSpriteNode(imageNamed: "hungover-hamster")
        hungoverHamster.setScale(0.75)
        hungoverHamster.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: hungoverHamster.size.width / 2, height: hungoverHamster.size.height / 2))
        hungoverHamster.physicsBody?.isDynamic = true
        hungoverHamster.physicsBody?.categoryBitMask = PhysicsCategory.hamster
        hungoverHamster.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // notify when it hit
        hungoverHamster.physicsBody?.collisionBitMask = PhysicsCategory.none // dont bounce off each other
        self.addChild(hungoverHamster)
        
        let yPos = random(min: hungoverHamster.size.height/2 + 100, max: size.height - hungoverHamster.size.height/2 - 100)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: size.width, y: yPos))
        
        path.addCurve(to: CGPoint(x: -hungoverHamster.size.width/4, y: yPos),
                      controlPoint1: CGPoint(x: size.width - size.width/4, y: yPos + 400),
                      controlPoint2: CGPoint(x: size.width/4, y: yPos - 400))
        
        let speed = random(min: CGFloat(2.0), max: CGFloat(5.0)) * 40
        let curve = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: speed)
        let removeFromScreen = SKAction.removeFromParent()
        let deductLives = SKAction.run() {self.deductLives()}
        
        hungoverHamster.run(SKAction.sequence([curve, deductLives, removeFromScreen]))
    }
    
    /**
     Wait until the player has played for a while to increase diffculty and add hungover hamter
     */
    func levelTwo(){
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(addHungoverHamsters),
            SKAction.wait(forDuration: 3.0, withRange: 2.0)
            ])
        ))
        run(
          SKAction.sequence([
            SKAction.wait(forDuration: 15.0),
            SKAction.run(levelThree)
            ]
        ))
    }
    
    /**
     Waiting a bit more after hungover hamster first appears to add hero hamsters
     */
    func levelThree(){
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run({self.addHamsters(isHeroHamster: true)}),
            SKAction.wait(forDuration: 3.0, withRange: 2.0)
            ])
        ))
    }
    
    /**
     Check if the number of lives has gone to zero, if so, transition to the game over scene
     */
    func deductLives() {
        livesLeft -= 1
        self.livesLabel.text = "Lives Left: \(self.livesLeft)"
        if livesLeft == 0 {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size)
            self.compareMaxPoints()
            if let maxPoints = UserDefaults.standard.string(forKey: "maxPoints") {
                gameOverScene.maxPoints = Int(maxPoints) ?? -1
            }
            gameOverScene.points = self.hamstersFed
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    /**
     When user takes their finger off the screen, we shoot a projectile in the angle where the touch was in these steps
     1. Set up initial location of projectile to where rooster is and create physics body
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
        if let currCharacter = UserDefaults.standard.string(forKey: "character") {
            if currCharacter == "looster"{
                projectile.position = looster.position
            } else{
                projectile.position = jooster.position
            }
        }
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.hamster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
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
    
    /**
     When hamster and projectile collide, remove both from the screen
     */
    func projectileDidCollideWithHamster(_ projectile: SKSpriteNode, _ hamster: SKSpriteNode) {
      hamstersFed += 1
      pointsLabel.text = "Hamsters Fed: \(hamstersFed)"
      projectile.removeFromParent()
      hamster.removeFromParent()
    }

    /**
     Compare if the user's points this turn is the max points, and update UserDefault if so
     */
    func compareMaxPoints(){
        if let currMax = UserDefaults.standard.string(forKey: "maxPoints") {
            if hamstersFed > Int(currMax) ?? 0 {
                UserDefaults.standard.set(hamstersFed, forKey: "maxPoints")
            }
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    /**
     Check if the two bodies that collided were the hamster/hungover hamster and projectile, if so, call projectileDidCollideWithHamster()
     TODO: Why do hamster collide with other hamster sometimes and disappear??
     */
    func didBegin(_ contact: SKPhysicsContact) {
      var firstBody: SKPhysicsBody
      var secondBody: SKPhysicsBody
      if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
     
      if ((firstBody.categoryBitMask & PhysicsCategory.hamster != 0) &&
          (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
        if let hamster = firstBody.node as? SKSpriteNode,
          let projectile = secondBody.node as? SKSpriteNode {
          projectileDidCollideWithHamster(projectile, hamster)
            }
        }
    }
}
 
