//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Oluwapelumi Williams on 06/09/2023.
//

import SwiftUI

struct ActionButton: View {
    var move: String
    
    var body: some View {
        Text("\(move)")
            .font(.title)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 0.85, green: 0.95, blue: 0.95))
            .foregroundColor(.primary)
            .clipShape(Capsule())
    }
}

//struct ActionButtonStyle: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .frame(maxWidth: .infinity)
//            .padding()
//            .background(Color(red: 0, green: 0.5, blue: 0.75))
//            .foregroundColor(.primary)
//            .clipShape(Capsule())
//    }
//}

struct ContentView: View {
    private let moves: [String] = ["Rock", "Paper", "Scissors"]
    @State private var score: Int = 0
    @State private var rounds: Int = 0
    
    private let MAX_ROUNDS: Int = 8
    
    @State private var appChoice = Int.random(in: 0...2)
    @State private var playerChoice: String = ""
    
    @State private var playerDirective: Bool = Bool.random()
    
    @State private var showingAlert: Bool = false
    @State private var scoreTitle: String = ""
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.19, green: 0.5, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.5, green: 0.8, blue:0.8), location: 0.3),
            ], center: .bottom, startRadius: 300, endRadius:650)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Rock • Paper • Scissors")
                    .font(.title.weight(.bold))
                    // .foregroundColor(.white)
                    // .padding()
                
                VStack(spacing: 20) {
                    VStack {
                        Text("Play to \(playerDirective ? "win" : "lose")")
                            .font(.title3.weight(.heavy))
                            .foregroundColor(.secondary)
                        Text("\(moves[appChoice])")
                            .font(.title).bold()
                            .padding([.top], 10)
                            .padding([.bottom], 80)
                        // .padding(.top, 30)
                        // Spacer()
                        
                        VStack {
                            ForEach(0..<3 ) { moveIndex in
                                Button {
                                    buttonTapped(moveIndex)
                                } label: {
                                    ActionButton(move: moves[moveIndex])
                                    //.buttonStyle(ActionButton)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                Spacer()
                Text("Score: \(score)")
                    .font(.title)
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingAlert) {
            Button("Reset", action:resetGame)
        } message: {
            Text("You won \(score) out of \(MAX_ROUNDS)!")
        }
    }
    
    func buttonTapped(_ moveIndex: Int) {
        playerChoice = moves[moveIndex]
        rounds += 1
        
        if determineWin() {
            score += 1
        }
        
        if rounds < MAX_ROUNDS {
            playerDirective = Bool.random()
            playerDirective.toggle()
            appChoice = Int.random(in: 0...2)
            //            print("yes, button works")
        } else {
            showingAlert = true
        }
    }
    
    func resetGame() {
        score = 0
        rounds = 0
    }
    
    func determineWin() -> Bool {
        // draws are not being considered here
        var roundResult = ""
        
        switch (playerChoice) {
        case "Rock":
            roundResult = moves[appChoice] == "Scissors" ? "win" : moves[appChoice] == "Paper" ? "lose" : "draw"
        case "Paper":
            roundResult = moves[appChoice] == "Rock" ? "win" : moves[appChoice] == "Scissors" ? "lose" : "draw"
        default:
            // case "Scissors":
            roundResult = moves[appChoice] == "Paper" ? "win" : moves[appChoice] == "Rock" ? "lose" : "draw"
        }
        
        // what happens if you won the Rock Paper Scissors round, and you were actually directed to win.
        switch(roundResult) {
        case("win"):
            return playerDirective ? true : false
        case("lose"):
            return !playerDirective ? true : false
        default:
            // case("draw")
            // player was supposed to either win or lose, so a draw means they lost overall
            return false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
