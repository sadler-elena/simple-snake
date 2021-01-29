//
//  GameOverView.swift
//  simple snake
//
//  Created by Elena Sadler on 1/18/21.
//

import SwiftUI

struct GameOverView: View {
    @State var score: Int
    @State var restart_game: Bool = false

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Game over :(")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Text("Score: \(self.score)")
                    .padding(.bottom, 10)

                Button(action: {
                    self.restart_game = true
                }) {
                    Image(systemName: "gobackward")
                        .font(.system(size: 30, weight: .bold))
                }

            }.foregroundColor(.white)
            
        }
        
        
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(score: 5)
    }
}
