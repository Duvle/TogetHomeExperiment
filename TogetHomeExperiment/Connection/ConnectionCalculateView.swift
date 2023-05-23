//
//  ConnectionCalculateView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/05/08.
//

import SwiftUI

struct ConnectionCalculateView: View {
    var body: some View {
        NavigationStack {
            List {
                HStack{
                    Spacer()
                    Text("Developing features...")
                        .font(.custom("SamsungOneKorean-400", size: 20))
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
        }
        .navigationTitle("Position Calculate")
        .refreshable {
        }
    }
}

struct ConnectionCalculateView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionCalculateView()
    }
}
