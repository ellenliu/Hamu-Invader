//
//  GameViewController.swift
//  Hamu Invaders
//
//  Created by Ellen Liu on 2020-04-05.
//  Copyright © 2020 Ellen Liu. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var characterChosen: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(characterChosen, forKey: "character")
        
        let scene = GameScene(size: view.bounds.size)
           if let skView = self.view as! SKView? {
               skView.ignoresSiblingOrder = true
               scene.scaleMode = .resizeFill
               skView.presentScene(scene)
           }
        if UserDefaults.standard.string(forKey: "maxPoints") == nil {
            UserDefaults.standard.set(0, forKey: "maxPoints")
        }
    }
        
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
