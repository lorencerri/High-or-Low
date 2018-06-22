//
//  ViewController.swift
//  High Or Low
//
//  Created by Loren Cerri on 6/13/18.
//  Copyright © 2018 Plexi Development. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AVFoundation

// Global Variables
var score = 0
var hiScore = 0
var lastPlay = "unknown"
var active = true

var leftCardName:String = "0"
var rightCardName:String = "0"

class ViewController: UIViewController, GADBannerViewDelegate {

    // AdMob - Banner
    var bannerView: GADBannerView!
    
    // Sound Effects
    var player: AVAudioPlayer?
    
    // Cards
    @IBOutlet weak var leftCard: UIImageView!
    @IBOutlet weak var rightCard: UIImageView!
    
    // Scores
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var highScore: UILabel!
    
    // Main Text
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var remainingText: UILabel!
    
    // Card Pool
    var cardPool:Array<String> = []
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Initialize the Google Mobile Ads SDK.
        // Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
        GADMobileAds.configure(withApplicationID: "ca-app-pub-5176087298578516~8279813497")
        
        return true
    }
    
    func getCardFromPool() -> String {
        
        var randomIndex:Int
        var card:String
        
        // This is to ensure that the leftCard is not the same as the card we are pulling from the deck to
        // be the right card
        repeat {
            randomIndex = Int(arc4random_uniform(UInt32(cardPool.count)))
            card = cardPool[randomIndex]
        } while (getNumberFromString(leftCardName) == getNumberFromString(card))
        
        cardPool.remove(at: randomIndex)
        return card
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fill Card Pool
        for x in 1...4 {
            for y in 2...14 {
                if x == 1 {
                    cardPool.append("heart\(y)")
                } else if x == 2 {
                    cardPool.append("club\(y)")
                } else if x == 3 {
                    cardPool.append("diamond\(y)")
                } else {
                    cardPool.append("spade\(y)")
                }
            }
        }
        
        // Fetch a card
        leftCardName = getCardFromPool()
        rightCardName = getCardFromPool()
        
        // Update Remaining Text
        remainingText.text = "51 Cards Remaining"
        
        // Update Left Card
        leftCard.image = UIImage(named: leftCardName)
        
        // Update High Score
        if let fetchedHighScore = UserDefaults.standard.object(forKey: "Highscore") as? Int {
            hiScore = fetchedHighScore
            highScore.text = "Highest Score: \(String(hiScore))"
        }
        
        // Update bannerView
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        self.view.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-5176087298578516/3574830468"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        let requestAd: GADRequest = GADRequest()
        requestAd.testDevices = [kGADSimulatorID]
        bannerView.load(requestAd)
        
    }
    
    // Hide Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "cardflip", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getNumberFromString(_ input: String) -> UInt32 {
        return UInt32(input.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890").inverted))!
    }
    
    // This will run when the higher button is tapped
    @IBAction func higherButtonTapped(_ sender: Any) {
        
        if !active {
            return
        }
        
        // Play Sound Effect
        playSound()
        
        // Update Hands Played
        if var fetchedHandsPlayed = UserDefaults.standard.object(forKey: "HandsPlayed") as? Int {
            fetchedHandsPlayed += 1
            UserDefaults.standard.set(fetchedHandsPlayed, forKey: "HandsPlayed")
        } else {
            UserDefaults.standard.set(1, forKey: "HandsPlayed")
        }
        
        // Check if the user guessed correctly
        if getNumberFromString(rightCardName) > getNumberFromString(leftCardName) { // Correct
            
            // Update Scores
            incrementScore()
            
            // Update Last Play
            lastPlay = "Correct!"
            
            // Update Cards
            generateNewCards()
            
        } else if getNumberFromString(rightCardName) < getNumberFromString(leftCardName) { // Incorrect
            
            // Reset Scores
            resetScore()
            
            // Update Last Play
            lastPlay = "Incorrect."
            
            // Generate New Cards
            generateNewCards()
            
        } else {
            print("Oops, something went wrong!")
        }
        
    }
    
    // This will run when the lower button is tapped
    @IBAction func lowerButtonTapped(_ sender: Any) {
        
        if !active {
            return
        }
        
        // Play Sound Effect
        playSound()
        
        // Update Hands Played
        if var fetchedHandsPlayed = UserDefaults.standard.object(forKey: "HandsPlayed") as? Int {
            fetchedHandsPlayed += 1
            UserDefaults.standard.set(fetchedHandsPlayed, forKey: "HandsPlayed")
        } else {
            UserDefaults.standard.set(1, forKey: "HandsPlayed")
        }
        
        // Check if the user guessed correctly
        if getNumberFromString(rightCardName) < getNumberFromString(leftCardName) { // Correct

            // Update Last Play
            lastPlay = "Correct!"

        } else if getNumberFromString(rightCardName) > getNumberFromString(leftCardName) { // Incorrect

            // Update Last Play
            lastPlay = "Incorrect."
            
        }
        
        // Reset Scores∂
        resetScore()
        
        // Generate New Cards
        generateNewCards()
        
    }
    
    func resetScore() {
        
        // Games Played
        if var fetchedGamesPlayed = UserDefaults.standard.object(forKey: "GamesPlayed") as? Int {
            fetchedGamesPlayed += 1
            UserDefaults.standard.set(fetchedGamesPlayed, forKey: "GamesPlayed")
        } else {
            UserDefaults.standard.set(1, forKey: "GamesPlayed")
        }
        
        // Update Cards
        cardPool = []
        for x in 1...4 {
            for y in 2...14 {
                if x == 1 {
                    cardPool.append("heart\(y)")
                } else if x == 2 {
                    cardPool.append("club\(y)")
                } else if x == 3 {
                    cardPool.append("diamond\(y)")
                } else {
                    cardPool.append("spade\(y)")
                }
            }
        }
        
        print(leftCardName)
        // Remove Left Card From Pool
        cardPool = cardPool.filter { $0 != rightCardName }
        
        // Perform Lose Popup Segue
        performSegue(withIdentifier: "loseSegue", sender: nil)
        currentScore.text = "Score: \(String(score))"
        
    }
    
    func incrementScore() {
        score += 1
        currentScore.text = "Score: \(String(score))"
        
        // Update highScore
        if score > hiScore {
            
            hiScore = score
            highScore.text = "Highest Score: \(String(hiScore))"
            
            // Save persistently in UserDefaults
            UserDefaults.standard.set(hiScore, forKey: "Highscore")
            
        }
        
        // Update Hands Won
        if var fetchedHandsWon = UserDefaults.standard.object(forKey: "HandsWon") as? Int {
            fetchedHandsWon += 1
            UserDefaults.standard.set(fetchedHandsWon, forKey: "HandsWon")
        } else {
            UserDefaults.standard.set(1, forKey: "HandsWon")
        }
        
    }
    
    func cardToEnglish(_ card: UInt32) -> String {
        
        if card == 14 {
            return "Ace"
        } else if card == 13 {
            return "King"
        } else if card == 12 {
            return "Queen"
        } else if card == 11 {
            return "Jack"
        } else {
            return String(card)
        }
        
    }
    
    func generateNewCards() {
        
        // Update Main Text
        if getNumberFromString(rightCardName) > getNumberFromString(leftCardName) {
            mainText.text = "\(lastPlay) \(cardToEnglish(getNumberFromString(rightCardName))) is greater than \(cardToEnglish(getNumberFromString(leftCardName)))"
        } else {
            mainText.text = "\(lastPlay) \(cardToEnglish(getNumberFromString(rightCardName))) is less than \(cardToEnglish(getNumberFromString(leftCardName)))"
        }
        
        // Set active status
        active = false
        
        // Show right card
        rightCard.image = UIImage(named: rightCardName)
        
        // Wait 1.5 seconds, then run the following...
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            
            // Move right card to left card
            self.leftCard.image = UIImage(named: rightCardName)
            leftCardName = rightCardName
            
            // Reset right card
            self.rightCard.image = UIImage(named: "back")
            
            // Update rightCardNumber
            rightCardName = self.getCardFromPool()
            
            self.remainingText.text = "\(self.cardPool.count + 1) \(self.cardPool.count + 1 > 1 ? "Cards" : "Card") Remaining"
            
            // Set active status
            active = true
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

    
