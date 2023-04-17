//
//  BeaconView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/04/01.
//

import SwiftUI

enum ViewOption {
    case all
    case specific
    case primary
}

struct BeaconOption {
    var mainTitle: String
    var subTitle: String
    var icon: String
    var targetView: ViewOption
}

@ViewBuilder func viewSelect(for viewoption: ViewOption) -> some View {
    switch viewoption {
    case .all:
        BeaconAllView()
    case .specific:
        BeaconSpecView()
    case .primary:
        BeaconPriView()
    }
}

struct BeaconView: View {
    @State var optionList = [
        BeaconOption(mainTitle: "All Beacon", subTitle: "Find all the Toget-Home's Beacon Broadcast Data.", icon: "globe.asia.australia", targetView: .all),
        BeaconOption(mainTitle: "Specific Beacon", subTitle: "Find a specific Toget-Home's Beacon Broadcast Data.", icon: "square.split.bottomrightquarter", targetView: .specific),
        BeaconOption(mainTitle: "Primary Beacon", subTitle: "Find a primary Toget-Home's Beacon Broadcast Data.", icon: "flag.checkered.circle", targetView: .primary)
    ]
    var body: some View {
        NavigationStack {
            List(optionList, id: \.mainTitle) { optionListData in
                NavigationLink(
                    destination: viewSelect(for: optionListData.targetView),
                    label: {
                        HStack {
                            Image(systemName: optionListData.icon)
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(Color("BluetoothColor"))
                                .padding(10)
                            VStack {
                                Text(optionListData.mainTitle)
                                    .font(.custom("SamsungOneKorean-700", size: 35))
                                    .frame(width: 250, alignment: .leading)
                                    .padding(.bottom, 1)
                                Text(optionListData.subTitle)
                                    .font(.custom("SamsungOneKorean-400", size: 10))
                                    .frame(width: 250, alignment: .leading)
                            }
                        }
                    }).frame(height: 150)
            }.navigationTitle("Beacon")
        }
    }
}

struct BeaconSpecView: View {
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
        .navigationTitle("Specific Beacon")
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

struct BeaconView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconView()
    }
}
