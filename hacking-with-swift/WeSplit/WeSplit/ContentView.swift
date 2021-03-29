//
//  ContentView.swift
//  WeSplit
//
//  Created by Rubens Pessoa De Barros Filho on 25.02.21.
//

import SwiftUI

struct ContentView: View {

    @State private var input = ""
    @State private var selectedInputUnit = 0
    @State private var selectedOutputUnit = 0

    let units: [UnitMass] = [.grams, .kilograms, .ounces, .pounds, .stones, .carats]

    var convertedInput: Double {
        let givenInput = Measurement(value: Double(input) ?? 0, unit: units[selectedInputUnit])
        return givenInput.converted(to: units[selectedOutputUnit]).value
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your input")) {
                    TextField("Input", text: $input)
                }

                Section(header: Text("Your input unit of measurment")) {
                    Picker("Input unit type", selection: $selectedInputUnit) {
                        ForEach(0 ..< self.units.count) {
                            Text("\(units[$0].symbol)")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }

                Section(header: Text("Your output unit of measurment")) {
                    Picker("Input unit type", selection: $selectedOutputUnit) {
                        ForEach(0 ..< self.units.count) {
                            Text("\(units[$0].symbol)")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }

                Section(header: Text("Your output")) {
                    Text("\(convertedInput)")
                        .foregroundColor(input == "0" ? .red : .blue)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
