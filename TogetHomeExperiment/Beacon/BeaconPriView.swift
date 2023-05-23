//
//  BeaconPriView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/05/08.
//

import SwiftUI

struct BeaconPriView: View {
    @State var isScanning: Bool = false
    
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
        .navigationTitle("Primary Beacon")
        .toolbar {
            ToolbarItem {
                Button {
                    isScanning.toggle()
                } label: {
                    Text(isScanning ? "Stop" : "Scan")
                        .font(.custom("SamsungOneKorean-700", size: 18))
                        .frame(width: 80, height: 30)
                        .background(isScanning ? Color("ScanStopColor") : Color("ScanStartColor"))
                        .foregroundColor(Color("BackgroundColor"))
                        .cornerRadius(15)
                }
            }
        }
        .refreshable {
        }
    }
}

struct BeaconPriView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconPriView()
    }
}
