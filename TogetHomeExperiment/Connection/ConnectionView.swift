//
//  ConnectionView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/04/01.
//

import SwiftUI

enum ConnectionViewOption {
    case test
    case transfer
    case calculate
}

struct ConnectionListOption {
    var mainTitle: String
    var subTitle: String
    var icon: String
    var targetView: ConnectionViewOption
}

@ViewBuilder func viewSelect(for viewoption: ConnectionViewOption) -> some View {
    switch viewoption {
    case .test:
        ConnectionTestView()
    case .transfer:
        ConnectionTransferView()
    case .calculate:
        ConnectionCalculateView()
    }
}

struct ConnectionView: View {
    @State var optionList = [
        ConnectionListOption(mainTitle: "Test Connect", subTitle: "Test only pure Socket communication with the Main Station Server.", icon: "captions.bubble", targetView: .test),
        ConnectionListOption(mainTitle: "Data Transfer", subTitle: "Data is exchanged with the Main Station Server.", icon: "server.rack", targetView: .transfer),
        ConnectionListOption(mainTitle: "Position Calculate", subTitle: "Test the Main Station Server and the actual indoor location service.", icon: "location.viewfinder", targetView: .calculate)
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

struct ConnectionTestView: View {
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
        .navigationTitle("Test Connect")
        .refreshable {
        }
    }
}

struct ConnectionTransferView: View {
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
        .navigationTitle("Data Transfer")
        .refreshable {
        }
    }
}

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

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
    }
}
