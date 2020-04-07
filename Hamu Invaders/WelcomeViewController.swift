//
//  WelcomeViewController.swift
//  Hamu Invaders
//
//  Created by Ellen Liu on 2020-04-07.
//  Copyright © 2020 Ellen Liu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBAction func loosterButton(_ sender: Any) {
        self.performSegue(withIdentifier: "LoosterGameViewControllerSegue", sender: self)
    }
    
    @IBAction func joosterButton(_ sender: Any) {
        self.performSegue(withIdentifier: "JoosterGameViewControllerSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
