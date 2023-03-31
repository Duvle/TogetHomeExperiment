//
//  ContentView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/04/01.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "wave.3.right.circle.fill")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Toget Home Experiment")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
