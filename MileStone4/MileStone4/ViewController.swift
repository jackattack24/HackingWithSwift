//
//  ViewController.swift
//  MileStone4
//
//  Created by Jack Mustacato on 1/15/18.
//  Copyright © 2018 Jack Mustacato. All rights reserved.
//

import GameplayKit
import UIKit

class ViewController: UIViewController {
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var guessesLabel: UILabel!
    
    var answer = ""
    var answerArray = [Character]()
    var guessed = [String]()
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var guesses = 7 {
        didSet {
            guessesLabel.text = "Guesses Left: \(guesses)"
        }
    }
    var questionMarks = 7
    
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
                   "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
                   "Y", "Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for subview in view.subviews where subview.tag == 1001 {
            let button = subview as! UIButton
            letterButtons.append(button)
            button.addTarget(self, action: #selector(letterTapped),
                             for: .touchUpInside)
        }
        
        loadGame()
    }
    
    func loadGame() {
        if let wordFilePath = Bundle.main.path(forResource: "7LetterWords",
                                               ofType: "txt") {
            if let gameContents = try? String(contentsOfFile: wordFilePath) {
                var lines = gameContents.components(separatedBy: "\n")
                
                lines =
                GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lines)
                as! [String]
                
                answer = lines[0]
                answerArray = Array(answer)
                guessed = ["?", "?", "?", "?", "?", "?", "?"]
                guesses = 7
                questionMarks = 7
            }
        }
        
        answerLabel.text = guessed.joined()
        
        for i in 0 ..< letters.count {
            letterButtons[i].setTitle(letters[i], for: .normal)
        }
    }
    
    @objc func letterTapped(button: UIButton) {
        activatedButtons.append(button)
        button.isHidden = true
        let letter = Character(button.titleLabel!.text!)
        
        if answer.contains(letter) {
            for i in 0 ..< answer.count {
                if letter == answerArray[i] {
                    guessed[i] = String(letter)
                    questionMarks -= 1
                }
            }
            
            answerLabel.text = guessed.joined()
            
            if questionMarks == 0 {
                win()
            }
        } else {
            guesses -= 1
            if guesses == 0 {
                gameOver()
                return
            }
            
            let ac =
                UIAlertController(title: "Incorrect Guess!",
                                  message: "That letter isn't in the word. Try again!",
                                  preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func win() {
        let ac =
            UIAlertController(title: "You're a winner!",
                              message: "You guessed the word correctly! Congrats!",
                              preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Play again", style: .default,
                                   handler: reload))
        present(ac, animated: true)
    }
    
    func gameOver() {
        let ac =
            UIAlertController(title: "Game Over",
                              message: "Sorry! You weren't able to guess the word. The word was \(answer)",
                              preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Play again", style: .default,
                                   handler: reload))
        present(ac, animated: true)
    }
    
    func reload(action: UIAlertAction) {
        loadGame()
        
        for button in letterButtons {
            button.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

