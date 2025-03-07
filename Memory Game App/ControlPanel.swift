import SwiftUI

struct ControlPanel: View {
    
    @ObservedObject var viewModel: CardGameViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Score: \(viewModel.score)")
                    .font(.headline)
                Spacer()
                Text("Moves: \(viewModel.moves)")
                    .font(.headline)
            }
            HStack {
                Button("New Game") {
                    withAnimation(.spring()) {
                        viewModel.startNewGame()
                    }
                }
                Spacer()
                Button("Shuffle") {
                    withAnimation(.spring()) {
                        viewModel.shuffleCards()
                    }
                }
            }
            if viewModel.gameOver {
                Text("Game Over!")
                    .font(.title)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
}
