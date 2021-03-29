//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Rubens Pessoa De Barros Filho on 19.03.21.
//

import SwiftUI

enum Option: String, CaseIterable {
    case rock, paper, scissors
}

struct ContentView: View {

    let winningResults: [Option: [Option: Bool]] = [
        .paper: [ .paper: false, .rock: true, .scissors: false],
        .rock: [ .paper: false, .rock: false, .scissors: true],
        .scissors: [ .paper: true, .rock: false, .scissors: false]
    ]

    @State private var round = 1
    @State private var score = 0
    @State private var shouldWin = Bool.random()
    @State private var appChosenOption = Int.random(in: 0...2)
    @State private var showRoundAlert = false
    @State private var roundAlertMessage = ""

    var body: some View {
        VStack {
            HStack {
                Text("Round: \(round)")
                    .padding()

                Text("Current score: \(score)")
                    .padding()
            }

            Text(shouldWin ? "You should win!" : "You should lose!")
                .font(.largeTitle)
                .padding()

            Text("Computer chose:")
                .padding()

            Text(Option.allCases[appChosenOption].rawValue.capitalized)
                .font(.title)
                .padding()

            Text("What's your choice?")
                .padding()

            HStack {
                ForEach(Option.allCases, id: \.self) { option in
                    Button(option.rawValue.capitalized) {
                        verifyResult(with: option, against: Option.allCases[appChosenOption])
                    }
                    .frame(width: 70, height: 70)
                    .foregroundColor(.white)
                    .background(Color.yellow)
                    .clipShape(Circle())
                }
            }
        }
        .alert(isPresented: $showRoundAlert) {
            Alert(title: Text("Testing"), message: Text(self.roundAlertMessage), dismissButton: .default(Text("OK"), action: {
                self.round += 1
                self.appChosenOption = Int.random(in: 0...2)
                self.shouldWin = Bool.random()

                if round == 11 {
                    self.score = 0
                    self.round = 0
                }
            }))
        }
    }

    func verifyResult(with userChoice: Option, against: Option)  {
        if let winningArray = winningResults[userChoice],
           let finalResult = winningArray[against] {
            if self.shouldWin {
                if finalResult {
                    self.score += 1
                    self.roundAlertMessage = "Good Job!"
                } else {
                    self.score -= 1
                    self.roundAlertMessage = "Wrong! Try again in the next round!"
                }
            } else {
                if finalResult {
                    self.score -= 1
                    self.roundAlertMessage = "Wrong! Try again in the next round!"
                } else {
                    self.score += 1
                    self.roundAlertMessage = "Good Job!"
                }
            }
        } else {
            self.roundAlertMessage = "Something went wrong. Try again!"
        }

        self.showRoundAlert = true

        if round + 1 == 11 {
            roundAlertMessage = "The game ended! Your score is \(score). Start again!"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
