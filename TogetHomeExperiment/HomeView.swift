//
//  HomeView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/04/01.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            Form{
                HStack{
                    Spacer()
                    VStack {
                        Image(systemName: "questionmark.folder")
                            .scaleEffect(2)
                            .foregroundColor(Color("OutlineColor"))
                        Text("\nNo Data")
                            .bold()
                    }.frame(height: 500)
                    Spacer()
                }
            }.navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
