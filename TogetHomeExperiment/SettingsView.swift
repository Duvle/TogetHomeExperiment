//
//  SettingsView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/04/01.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form{
                Text("Application Settings Page")
            }.navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
