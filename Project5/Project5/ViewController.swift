//
//  ViewController.swift
//  Project5
//
//  Created by Jack Mustacato on 1/8/18.
//  Copyright © 2018 Jack Mustacato. All rights reserved.
//

import GameplayKit
import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .add, target: self,
                        action: #selector(promptForAnswer))
        
        if let startWordsPath = Bundle.main.path(forResource: "start",
                                                 ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                allWords = startWords.components(separatedBy: "\n")
            } else {
                allWords = ["silkworm"]
            }
        }
        
        startGame()
    }
    
    func startGame() {
        allWords =
        GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords)
        as! [String]
        title = allWords[0]
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil,
                                   preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [unowned self, ac] _ in
                let answer = ac.textFields![0]
                self.submit(answer: answer.text!)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(answer: String) {
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if lowerAnswer == title!.lowercased() {
            errorTitle = "Word same as base word"
            errorMessage = "You can't use the base word as an answer!"
            showErrorMessage(errorTitle, errorMessage)
            return
        }
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    errorTitle = "Word not recognized"
                    errorMessage = "You can't just make them up, you know!"
                    showErrorMessage(errorTitle, errorMessage)
                }
            } else {
                errorTitle = "Word used already"
                errorMessage = "Be more original!"
                showErrorMessage(errorTitle, errorMessage)
            }
        } else {
            errorTitle = "Word not possible"
            errorMessage =
            "You can't spell that word from \(title!.lowercased())"
            showErrorMessage(errorTitle, errorMessage)
        }
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = title!.lowercased()
        
        for letter in word {
            if let pos = tempWord.range(of: String(letter)) {
                tempWord.remove(at: pos.lowerBound)
            }
            else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word,
                                                            range: range,
                                                            startingAt: 0,
                                                            wrap: false,
                                                            language: "en")
        
        return word.count > 0 && misspelledRange.location == NSNotFound
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    func showErrorMessage(_ errorTitle: String, _ errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage,
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word",
                                                 for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
