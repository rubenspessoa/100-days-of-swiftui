//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Rubens Pessoa De Barros Filho on 27.02.21.
//

import SwiftUI

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct FlagImage: View {
    let country: String

    var body: some View {
        Image(self.country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.black, lineWidth: 1)
                    .shadow(color: .black, radius: 2)
            )
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0..<3)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    @State private var selectedFlag: Int? = nil
    @State private var animationAmount = 0.0
    @State private var attempts = 0


    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)

                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }

                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        if (self.selectedFlag == nil) {
                            FlagImage(country: self.countries[number])
                        } else if (self.selectedFlag == number) {
                            FlagImage(country: self.countries[number])
                                .rotation3DEffect(.degrees(animationAmount), axis: (x: 0.0, y: 1.0, z: 0.0))
                                .modifier(Shake(animatableData: CGFloat(attempts)))
                        } else {
                            FlagImage(country: self.countries[number])
                                .opacity(0.25)
                        }
                    }


                }

                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                })
        }
    }

    func flagTapped(_ number: Int) {
        selectedFlag = number

        if number == self.correctAnswer {
            score += 1
            scoreTitle = "Correct"
            scoreMessage = "Your score is \(score)"

            withAnimation {
                self.animationAmount += 360
            }
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "Your score is \(score). This flag is from \(countries[number])"

            withAnimation {
                self.attempts += 1
            }
        }

        showingScore = true
    }

    func askQuestion() {
        selectedFlag = nil
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
