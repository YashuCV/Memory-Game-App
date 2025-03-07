import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: CardGameViewModel
    let card: Card
    @State private var dragAmount: CGSize = .zero
    @State private var rotationAngle: Double = 0.0
    
    var body: some View {
        ZStack {
            CardFront(content: card.content)
                .opacity(card.isFaceUp ? 1 : 0)
            CardBack()
                .opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isMatched ? 0.6 : 1.0)
        .rotation3DEffect(
            .degrees(rotationAngle),
            axis: (x: 0, y: 1, z: 0)
        )
        .offset(dragAmount)
        .gesture(dragGesture)
        .gesture(tapGesture)
        .animation(.spring(), value: dragAmount)
        .animation(.easeInOut, value: rotationAngle)
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragAmount = value.translation
            }
            .onEnded { _ in
                withAnimation {
                    dragAmount = .zero
                }
            }
    }
    private var tapGesture: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                flipCard()
            }
    }
    
    private func flipCard() {
        withAnimation(.easeInOut(duration: 0.3)) {
            rotationAngle += 180
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            viewModel.selectCard(card)
        }
    }
}

private struct CardFront: View {
    
    let content: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .overlay(
                Text(content)
                    .font(.largeTitle)
            )
            .shadow(radius: 4)
    }
}

private struct CardBack: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.blue)
            .overlay(
                StripePattern()
                    .stroke(Color.white, lineWidth: 2)
            )
            .shadow(radius: 4)
    }
}

struct StripePattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let stripeCount = 6
        let stripeWidth = rect.width / CGFloat(stripeCount * 2)
        
        for i in 0..<stripeCount {
            let x = CGFloat(i) * stripeWidth * 2
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
        }
        
        return path
    }
}
