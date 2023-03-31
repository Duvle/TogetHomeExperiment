//
//  BeaconView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/04/01.
//

import SwiftUI

struct BeaconView: View {
    var body: some View {
        NavigationView {
            Form{
                Text("Beacon Scanning Data Page")
            }.navigationTitle("Beacon")
        }
    }
}

struct BeaconView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconView()
    }
}
