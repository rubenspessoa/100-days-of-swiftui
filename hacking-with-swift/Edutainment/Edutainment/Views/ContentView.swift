//
//  ContentView.swift
//  Edutainment
//
//  Created by Rubens Pessoa De Barros Filho on 24.03.21.
//

import SwiftUI

struct Question: Hashable  {
    var question: String
    var answer: String
}

struct ContentView: View {
    static let questionAmounts = ["All", "5", "10", "20"]
    @State private var allQuestions = [Int: [Question]]()

    // Configuration States
    @State private var configMode = true
    @State private var upToMultiplicationTable = 1
    @State private var selectedQuestionAmountIndex = 0

    // Question States
    @State private var randomlySelectedQuestions = [Question]()
    @State private var answers = [Question: Int]()
    @State private var currentQuestionIndex = 0
    @State private var currentAnswer = ""

    // Alert States
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var presentAlert = false

    var body: some View {
        NavigationView {
            Group {
                if (configMode) {
                    Form {
                        Stepper("Up to the multiplication table of \(upToMultiplicationTable)", value: $upToMultiplicationTable, in: 1...10)

                        Picker("How many questions do you wanna answer?", selection: $selectedQuestionAmountIndex) {
                            ForEach(0..<ContentView.questionAmounts.count) {
                                Text(ContentView.questionAmounts[$0]).tag($0)
                            }
                        }

                        Button("Iniciar") {
                            configMode = false
                            generateQuestions()
                        }
                    }
                } else {
                    Form {
                        Text(randomlySelectedQuestions[currentQuestionIndex].question)

                        TextField("What's the answer?", text: $currentAnswer)
                            .keyboardType(.numberPad)

                        Button("Verify!") {
                            verifyAnswer()
                        }
                    }
                }
            }
            .navigationTitle(Text("Multiplication Table"))
        }
        .alert(isPresented: $presentAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("CONTINUE")) {
                print("CONTINUE")
            })
        }
        .onAppear {
            let numbersArray: [Int] = Array(1..<11)
            numbersArray.forEach { multiplicant in
                var questions: [Question] = []

                numbersArray.forEach { multiplier in
                    let newQuestion = Question(question: "How much is \(multiplicant) x \(multiplier)?", answer: String("\(multiplicant * multiplier)"))
                    questions.append(newQuestion)
                }

                allQuestions[multiplicant] = questions
            }
            configMode = true
        }
    }

    func verifyAnswer() {
        if (currentAnswer == randomlySelectedQuestions[currentQuestionIndex].answer) {
            alertTitle = "Awesome!"
            alertMessage = "Keep on going, let's master the multiplication table!"
        } else {
            alertTitle = "Oh no!"
            alertMessage = "No problem! You can try again next time!"
        }

        presentAlert = true

        if ContentView.questionAmounts[selectedQuestionAmountIndex] == "All" {
            if (currentQuestionIndex + 1 >= randomlySelectedQuestions.count) {
                currentQuestionIndex = 0
                generateQuestions()
                configMode = true
            } else {
                currentQuestionIndex += 1
            }
        } else if ContentView.questionAmounts[selectedQuestionAmountIndex] == "5" {
            if (currentQuestionIndex + 1 >= 5) {
                currentQuestionIndex = 0
                generateQuestions()
                configMode = true
            } else {
                currentQuestionIndex += 1
            }
        } else if ContentView.questionAmounts[selectedQuestionAmountIndex] == "10" {
            if (currentQuestionIndex + 1 >= 10) {
                currentQuestionIndex = 0
                generateQuestions()
                configMode = true
            } else {
                currentQuestionIndex += 1
            }
        } else if ContentView.questionAmounts[selectedQuestionAmountIndex] == "20" {
            if (currentQuestionIndex + 1 >= 20) {
                currentQuestionIndex = 0
                generateQuestions()
                configMode = true
            } else {
                currentQuestionIndex += 1
            }
        }


        currentAnswer = ""
    }

    func generateQuestions() {
        randomlySelectedQuestions = []
        var maxNumOfQuestions = 0

        guard selectedQuestionAmountIndex != 0 else {
            let multiplicantsArray = Array(1...upToMultiplicationTable)
            multiplicantsArray.forEach {
                if let questions = allQuestions[$0] {
                    var tempArray = [Question]()
                    tempArray.append(contentsOf: questions)
                    randomlySelectedQuestions = tempArray.shuffled()
                }
            }
            return
        }

        if selectedQuestionAmountIndex == 1 {
            maxNumOfQuestions = 5
        } else if selectedQuestionAmountIndex == 2 {
            maxNumOfQuestions = 10
        } else if selectedQuestionAmountIndex == 3 {
            maxNumOfQuestions = 20
        }

        while (randomlySelectedQuestions.count < maxNumOfQuestions) {
            let randomNumber = Int.random(in: 1...upToMultiplicationTable)

            if let questions = allQuestions[randomNumber] {
                let randomIndex = Int.random(in: 0 ..< questions.count)
                randomlySelectedQuestions.append(questions[randomIndex])
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
