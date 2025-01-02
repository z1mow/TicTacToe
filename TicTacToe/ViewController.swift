//
//  ViewController.swift
//  TicTacToe
//
//  Created by Şakir Yılmaz ÖĞÜT on 2.01.2025.
//

import UIKit

class ViewController: UIViewController {
    
    enum Turn {
        case Naught
        case Cross
    }
    
    enum Language {
        case Turkish
        case English
    }
    
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
    var firstTurn = Turn.Cross
    var currentTurn = Turn.Cross
    
    var NOUGHT = "O"
    var CROSS = "X"
    var board = [UIButton]()
    
    var noughtsScore = 0
    var crossesScore = 0
    
    var currentLanguage = Language.English
    
    // Localized strings
    var localizedStrings: [String: [Language: String]] = [
        "noughts": [.English: "Noughts", .Turkish: "Sıfırlar"],
        "crosses": [.English: "Crosses", .Turkish: "Çarpılar"],
        "noughtsWin": [.English: "Noughts Win!", .Turkish: "Sıfırlar Kazandı!"],
        "crossesWin": [.English: "Crosses Win!", .Turkish: "Çarpılar Kazandı!"],
        "draw": [.English: "Draw", .Turkish: "Berabere"],
        "reset": [.English: "Reset", .Turkish: "Yeniden Başlat"],
        "changeLang": [.English: "🇬🇧", .Turkish: "🇹🇷"],
        "turnTitle": [.English: "Turn", .Turkish: "Sıra"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
        setupLanguageButton()
        updateTurnLabel()
        updateSymbolLabel()
    }
    
    func setupLanguageButton() {
        languageButton.setTitle(localizedStrings["changeLang"]?[currentLanguage], for: .normal)
    }
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        currentLanguage = currentLanguage == .English ? .Turkish : .English
        updateUILanguage()
    }
    
    func updateUILanguage() {
        languageButton.setTitle(localizedStrings["changeLang"]?[currentLanguage], for: .normal)
        updateTurnLabel()
        updateSymbolLabel()
        
        // Update any visible alert if present
        if presentedViewController is UIAlertController {
            dismiss(animated: true) {
                if self.fullBoard() {
                    self.resultAlert(title: self.localizedStrings["draw"]?[self.currentLanguage] ?? "Draw")
                } else if self.checkForVictory(self.CROSS) {
                    self.resultAlert(title: self.localizedStrings["crossesWin"]?[self.currentLanguage] ?? "Crosses Win!")
                } else if self.checkForVictory(self.NOUGHT) {
                    self.resultAlert(title: self.localizedStrings["noughtsWin"]?[self.currentLanguage] ?? "Noughts Win!")
                }
            }
        }
    }
    
    func initBoard() {
        board.append(a1)
        board.append(a2)
        board.append(a3)
        board.append(b1)
        board.append(b2)
        board.append(b3)
        board.append(c1)
        board.append(c2)
        board.append(c3)
    }
    
    @IBAction func boardTapAction(_ sender: UIButton) {
        addToBoard(sender)
        
        if checkForVictory(CROSS) {
            crossesScore += 1
            resultAlert(title: localizedStrings["crossesWin"]?[currentLanguage] ?? "Crosses Win!")
        }
        
        if checkForVictory(NOUGHT) {
            noughtsScore += 1
            resultAlert(title: localizedStrings["noughtsWin"]?[currentLanguage] ?? "Noughts Win!")
        }
        
        if fullBoard() {
            resultAlert(title: localizedStrings["draw"]?[currentLanguage] ?? "Draw")
        }
    }
    
    func checkForVictory(_ s: String) -> Bool {
        // Horizontal Victory
        
        if thisSymbol(a1, s) && thisSymbol(a2, s) && thisSymbol(a3, s) {
            return true
        }
        if thisSymbol(b1, s) && thisSymbol(b2, s) && thisSymbol(b3, s) {
            return true
        }
        if thisSymbol(c1, s) && thisSymbol(c2, s) && thisSymbol(c3, s) {
            return true
        }
        
        // Vertical Victory
        
        if thisSymbol(a1, s) && thisSymbol(b1, s) && thisSymbol(c1, s) {
            return true
        }
        if thisSymbol(a2, s) && thisSymbol(b2, s) && thisSymbol(c2, s) {
            return true
        }
        if thisSymbol(a3, s) && thisSymbol(b3, s) && thisSymbol(c3, s) {
            return true
        }
        
        // Diagonal Victory
        
        if thisSymbol(a1, s) && thisSymbol(b2, s) && thisSymbol(c3, s) {
            return true
        }
        if thisSymbol(a3, s) && thisSymbol(b2, s) && thisSymbol(c1, s) {
            return true
        }
        
        
        
        
        return false
    }
    
    func thisSymbol(_ button: UIButton, _ symbol: String) -> Bool {
        return button.title(for: .normal) == symbol
    }
    
    func resultAlert(title: String) {
        let noughtsText = localizedStrings["noughts"]?[currentLanguage] ?? "Noughts"
        let crossesText = localizedStrings["crosses"]?[currentLanguage] ?? "Crosses"
        let message = "\n\(noughtsText): \(noughtsScore)\n\n\(crossesText): \(crossesScore)"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: localizedStrings["reset"]?[currentLanguage] ?? "Reset", style: .default, handler: { _ in
            self.resetBoard()
        }))
        self.present(ac, animated: true)
    }
    
    func resetBoard() {
        for button in board {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        if firstTurn == Turn.Naught {
            firstTurn = Turn.Cross
            currentTurn = Turn.Cross
            updateTurnLabel()
            updateSymbolLabel()
        }
        else if firstTurn == Turn.Cross {
            firstTurn = Turn.Naught
            currentTurn = Turn.Naught
            updateTurnLabel()
            updateSymbolLabel()
        }
    }
    
    func fullBoard() -> Bool {
        for button in board {
            if button.title(for: .normal) == nil {
                return false
            }
        }
        return true
    }
    
    
    func addToBoard(_ sender: UIButton) {
        if sender.title(for: .normal) == nil {
            if currentTurn == Turn.Naught {
                sender.setTitle(NOUGHT, for: .normal)
                currentTurn = Turn.Cross
                updateTurnLabel()
                updateSymbolLabel()
            }
            else if currentTurn == Turn.Cross {
                sender.setTitle(CROSS, for: .normal)
                currentTurn = Turn.Naught
                updateTurnLabel()
                updateSymbolLabel()
            }
            sender.isEnabled = false
        }
    }
    
    func updateTurnLabel() {
        let turnTitle = localizedStrings["turnTitle"]?[currentLanguage] ?? "Turn"
        turnLabel.text = turnTitle
    }
    
    func updateSymbolLabel() {
        symbolLabel.text = currentTurn == .Cross ? CROSS : NOUGHT
    }
    
}

