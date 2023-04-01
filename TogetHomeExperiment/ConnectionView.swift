//
//  ConnectionView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/04/01.
//

import SwiftUI

struct ConnectionView: View {
    var body: some View {
        NavigationStack {
            Form{
                Text("Server Connection Page")
            }.navigationTitle("Connection")
        }
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
    }
}
