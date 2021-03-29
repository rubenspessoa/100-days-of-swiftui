//
//  HomeView.swift
//  Edutainment
//
//  Created by Rubens Pessoa De Barros Filho on 24.03.21.
//

import SwiftUI

struct HomeView: View {
    static let animals = ["giraffe", "hippo", "goat"]

    @State private var isAnimating = false

    var foreverAnimation: Animation {
        Animation.spring()
            .repeatForever(autoreverses: true)
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Edutaintment")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)

                HStack(alignment: .center, spacing: -40) {
                    ForEach(HomeView.animals, id: \.self) {
                        Image($0)
                            .rotationEffect(.degrees( isAnimating ? Double(360) : 0.0))
                            .onAppear {
                                DispatchQueue.main.async {
                                    withAnimation(foreverAnimation) {
                                        isAnimating = true
                                    }

                                }
                            }
                            .onDisappear {
                                DispatchQueue.main.async {
                                    isAnimating = false
                                }
                            }
                    }
                }

                NavigationLink(
                    destination: ContentView(),
                    label: {
                        Text("START")
                            .bold()
                            .padding()
                            .frame(width: 100, height: 50, alignment: .center)
                            .foregroundColor(.red)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.red, lineWidth: 4)
                            )
                            .padding()
                    })
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
