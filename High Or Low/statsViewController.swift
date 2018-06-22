//
//  statsViewController.swift
//  High Or Low
//
//  Created by Loren School on 6/14/18.
//  Copyright © 2018 Plexi Development. All rights reserved.
//

import UIKit

class statsViewController: UIViewController {

    // Labels
    @IBOutlet weak var highestScore: UILabel!
    @IBOutlet weak var averageScore: UILabel!
    
    @IBOutlet weak var gamesPlayed: UILabel!
    
    @IBOutlet weak var handsPlayed: UILabel!
    @IBOutlet weak var handsWon: UILabel!
    @IBOutlet weak var handsLost: UILabel!
    
    // Dismiss Button
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Highest Score
        if let fetchedHighScore = UserDefaults.standard.object(forKey: "Highscore") as? Int {
            highestScore.text = "Highest Score: \(String(fetchedHighScore))"
        }
        
        // Average Score
        if let fetchedAverageScore = UserDefaults.standard.object(forKey: "AverageScore") as? Int {
            averageScore.text = "Average Score: \(String(fetchedAverageScore))"
        }
        
        // Games Played & Hands Lost
        if let fetchedGamesPlayed = UserDefaults.standard.object(forKey: "GamesPlayed") as? Int {
            gamesPlayed.text = "Games Played: \(String(fetchedGamesPlayed))"
            handsLost.text = "Hands Lost: \(String(fetchedGamesPlayed))"
        }
        
        // Hands Played
        if let fetchedHandsPlayed = UserDefaults.standard.object(forKey: "HandsPlayed") as? Int {
            handsPlayed.text = "Hands Played: \(String(fetchedHandsPlayed))"
        }
        
        // Hands Won
        if let fetchedHandsWon = UserDefaults.standard.object(forKey: "HandsWon") as? Int {
            handsWon.text = "Hands Won: \(String(fetchedHandsWon))"
            
            // Average Score
            if let fetchedGamesPlayed = UserDefaults.standard.object(forKey: "GamesPlayed") as? Int {
                let average:Double = round(100*(Double(fetchedHandsWon) / Double(fetchedGamesPlayed)))/100
                averageScore.text = "Average Score: \(average)"
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Hide Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
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
