//
//  HomeView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/04/01.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            Form{
                HStack{
                    Spacer()
                    VStack {
                        Image(systemName: "questionmark.folder")
                            .font(.system(size: 40, weight: .medium))
                            .foregroundColor(Color("OutlineColor"))
                        Text("No Data")
                            .foregroundColor(.gray)
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
