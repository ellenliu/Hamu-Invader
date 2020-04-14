//
//  WelcomeViewController.swift
//  Hamu Invaders
//
//  Created by Ellen Liu on 2020-04-07.
//  Copyright © 2020 Ellen Liu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var characterChosen: String = ""
    
    @IBAction func loosterButton(_ sender: Any) {
        characterChosen = "looster"
        self.performSegue(withIdentifier: "LoosterGameViewControllerSegue", sender: self)
        
    }
    
    @IBAction func joosterButton(_ sender: Any) {
        characterChosen = "jooster"
        self.performSegue(withIdentifier: "JoosterGameViewControllerSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? GameViewController {
            destinationVC.characterChosen = characterChosen
        }
    }
    

}
