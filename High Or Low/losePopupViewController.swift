//
//  losePopupViewController.swift
//  High Or Low
//
//  Created by Loren Cerri on 6/16/18.
//  Copyright © 2018 Plexi Development. All rights reserved.
//

import UIKit

class Player {
    
    let name: String!
    let highScore: Int!
    
    init(name: String, highScore: Int) {
        self.name = name
        self.highScore = highScore
    }
    
}

class losePopupViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nameValue: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    // Hide Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Update Score Text
        scoreLabel.text = "Score: \(score)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tryAgainButtonTapped(_ sender: Any) {
        
        // Reset Score
        score = 0
    
        dismiss(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
