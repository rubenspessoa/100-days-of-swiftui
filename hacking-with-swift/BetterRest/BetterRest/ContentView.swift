//
//  ContentView.swift
//  BetterRest
//
//  Created by Rubens Pessoa De Barros Filho on 20.03.21.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    @State private var recommendedBedtime = ""

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?").font(.headline)) {
                    DatePicker("Please enter a time:", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                        .onChange(of: wakeUp) { _ in
                            self.calculateBedtime()
                        }
                }

                Section(header: Text("Desired amount of sleep").font(.headline)) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g")")
                    }
                    .onChange(of: sleepAmount) { _ in
                        self.calculateBedtime()
                    }
                }

                Section(header: Text("Daily coffee intake")
                            .font(.headline)) {
                    Picker(selection: $coffeeAmount, label: Text("Number of cups"), content: {
                        ForEach(1..<20) {
                            Text("\($0)")
                        }
                    })
                    .onChange(of: coffeeAmount) { _ in
                        self.calculateBedtime()
                    }
                }

                Text("Your recommended bedtime is \(recommendedBedtime)")
                    .font(.largeTitle)
            }
            .onAppear(perform: {
                self.calculateBedtime()
            })
            .navigationBarTitle(Text("BetterRest"))
            .navigationBarItems(trailing: Button(action: calculateBedtime) {
                Text("Calculate")
            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }

    func calculateBedtime() {
        let model = SleepCalculator()

        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60

        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep

            let formatter = DateFormatter()
            formatter.timeStyle = .short

            recommendedBedtime = formatter.string(from: sleepTime)
        } catch {
            recommendedBedtime = "Sorry, there was a problem calculating your bedtime"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
