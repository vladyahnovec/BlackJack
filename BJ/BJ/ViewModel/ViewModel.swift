import SwiftUI

class ViewModel: ObservableObject {
    @Published var currentView = "HomeView"
    @Published var checker = false {
        didSet {
            if checker {
                dilerCards[0] = dilerCard
                giveScore(deck: dilerCards, score: &dilerScore)
            }
        }
    }
    @Published var cards: [String] = []
    @Published var suit = ["♥", "♦", "♣", "♠"]
    @Published var value: [String] = []
    @Published var stavka = "100"
    @Published var count = ""
    @Published var bank = "1000"
    @Published var myCards: [String] = []
    @Published var dilerCards: [String] = []
    @Published var dilerCard = ""
    @Published var myScore: Int = 0
    @Published var dilerScore: Int = 0
    @Published var whoWin = ""
    
    init() {
        createDeckCards()
     }
    
    func createDeckCards() {
        createValues()
        for s in 0..<suit.count {
            for v in 0..<value.count {
                cards.append("\(value[v]) \(suit[s])")
            }
        }
    }
    
    private func createValues() {
        value = (2...10).map { String($0) }
        value += ["J", "Q", "K", "A"]
    }
    
    func giveCards(deck: inout [String], otherDeck: [String], cd: String?) {
        deck.removeAll()
        for _ in 0...1 {
            var card: String
            repeat {
                let index = Int.random(in: 0..<self.cards.count)
                card = self.cards[index]
            } while deck.contains(card) || otherDeck.contains(card)
            deck.append(card)
        }
        if cd != nil {
            dilerCard = deck[0]
            deck[0] = "rybashka"
        }
    }
    
    func giveScore(deck: [String], score: inout Int) {
        score = 0
        for card in deck {
            let components = card.split(separator: " ")
            if let cardValueString = components.first, let cardValue = getCardValue(from: String(cardValueString)) {
                score += cardValue
            }
        }
    }
    
    func giveCard(deck: inout [String]) {
        var card: String
        
        if !checker {
            repeat {
                let index = Int.random(in: 0..<self.cards.count)
                card = self.cards[index]
            } while deck.contains(card)
            deck.append(card)
        } else {
            while dilerScore < 21 && dilerScore <= myScore {
                let index = Int.random(in: 0..<self.cards.count)
                card = self.cards[index]
                deck.append(card)
                giveScore(deck: deck, score: &dilerScore)
            }
        }
    }
    
    
    private func getCardValue(from cardValueString: String) -> Int? {
        switch cardValueString {
        case "J", "Q", "K":
            return 10
        case "A":
            return 11
        default:
            return Int(cardValueString)
        }
    }
    
    func determineWinner() {
        if myScore > 21 {
            whoWin = "Победа дилера!!!!! -\(stavka)"
            count = "-" + stavka
        } else if dilerScore > 21 {
            whoWin = "Победа игрока! )) +\(Int(stavka)! * 2)"
            count = "+" + String(Int(stavka)! * 2)
        } else if myScore > dilerScore {
            whoWin = "+" + "Победа игрока! ) +\(Int(stavka)! * 2)"
            count = String(Int(stavka)! * 2)
        } else if dilerScore > myScore {
            whoWin = "Победа дилера!! -\(stavka)"
            count = "-" + stavka
        } else {
            whoWin = "Ничья"
            count = stavka
        }
        updateBank()
    }
    
    private func updateBank() {
        if whoWin == "Победа игрока! +\(Int(stavka)! * 2)" {
            bank = String(Int(bank)! + 2 * Int(stavka)!)
        } else if whoWin == "Победа дилера!!!!!!!!! -\(stavka)"
        {
            bank = String(Int(bank)! - Int(stavka)!)
        }
    }
}
