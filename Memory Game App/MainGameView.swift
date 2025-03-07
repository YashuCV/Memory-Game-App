import SwiftUI

struct MainGameView: View {
    @StateObject private var viewModel = CardGameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            
            ZStack {
                Color(red: 0.85, green: 0.93, blue: 1.0)
                    .ignoresSafeArea()
                
                if isLandscape {
                    HStack {
                        cardGrid(in: geometry.size)
                        ControlPanel(viewModel: viewModel)
                            .frame(width: geometry.size.width * 0.3)
                    }
                } else {
                    VStack {
                        cardGrid(in: geometry.size)
                        ControlPanel(viewModel: viewModel)
                            .frame(height: geometry.size.height * 0.25)
                    }
                }
            }
        }
    }
    func cardGrid(in size: CGSize) -> some View {
        let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 6), count: 4)
        
        return LazyVGrid(columns: columns, spacing: 6) {
            ForEach(viewModel.cards.prefix(12)) { card in
                CardView(viewModel: viewModel, card: card)
                    .frame(width: size.width / 4.5, height: (size.width / 4.5) * 1.5)
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .padding()
    }
}
