import SwiftUI
final class CardGameViewModel: ObservableObject {
    
    @Published var cards: [Card] = []
    @Published var score: Int = 0
    @Published var moves: Int = 0
    @Published var gameOver: Bool = false
    private var firstSelectedCardIndex: Int? = nil
    private let emojiSet = ["🏏","🌎","🦮","🍎","🧶","🦊","🎩","🚀"]
    private let totalPairs = 6
    init() {
        startNewGame()
    }
    func startNewGame() {
        score = 0
        moves = 0
        gameOver = false
        firstSelectedCardIndex = nil
        let chosenEmojis = emojiSet.prefix(totalPairs)
        var newCards: [Card] = []
        for emoji in chosenEmojis {
            let cardA = Card(isFaceUp: false, isMatched: false, content: emoji)
            let cardB = Card(isFaceUp: false, isMatched: false, content: emoji)
            newCards.append(cardA)
            newCards.append(cardB)
        }
        newCards.shuffle()
        cards = newCards
    }
    func shuffleCards() {
        cards.shuffle()
    }
    func selectCard(_ card: Card) {
        guard let selectedIndex = cards.firstIndex(where: { $0.id == card.id }) else {
            return
        }
        if cards[selectedIndex].isMatched || cards[selectedIndex].isFaceUp {
            return
        }
        cards[selectedIndex].isFaceUp = true
        
        if let firstIndex = firstSelectedCardIndex {
            moves += 1
            if cards[firstIndex].content == cards[selectedIndex].content {
                cards[firstIndex].isMatched = true
                cards[selectedIndex].isMatched = true
                score += 2
                if cards.allSatisfy({ $0.isMatched }) {
                    gameOver = true
                }
            } else {
                if score > 0 {
                    score -= 1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.cards[firstIndex].isFaceUp = false
                    self.cards[selectedIndex].isFaceUp = false
                }
            }
            firstSelectedCardIndex = nil
            
        } else {
            for i in 0..<cards.count {
                if !cards[i].isMatched && i != selectedIndex {
                    cards[i].isFaceUp = false
                }
            }
            firstSelectedCardIndex = selectedIndex
        }
    }
}
