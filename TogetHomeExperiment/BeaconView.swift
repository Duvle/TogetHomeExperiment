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
            Form {
                NavigationLink(
                    destination: BeaconAllView(),
                    label: {
                        HStack {
                            Image(systemName: "globe.asia.australia")
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(Color("BluetoothColor"))
                                .padding(10)
                            VStack {
                                Text("All Beacon")
                                    .font(.custom("SamsungOneKorean-700", size: 35))
                                    .frame(width: 250, alignment: .leading)
                                    .padding(.bottom, 1)
                                Text("Find all the Toget-Home's Beacon Broadcast Data.")
                                    .font(.custom("SamsungOneKorean-400", size: 10))
                                    .frame(width: 250, alignment: .leading)
                            }
                        }
                    }).frame(height: 150)
                NavigationLink(
                    destination: BeaconSpecView(),
                    label: {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(Color("BluetoothColor"))
                                .padding(10)
                            VStack {
                                Text("Specific Beacon")
                                    .font(.custom("SamsungOneKorean-700", size: 35))
                                    .frame(width: 250, alignment: .leading)
                                    .padding(.bottom, 1)
                                Text("Find a specific Toget-Home's Beacon Broadcast Data.")
                                    .font(.custom("SamsungOneKorean-400", size: 10))
                                    .frame(width: 250, alignment: .leading)
                            }
                        }
                    }).frame(height: 150)
            }.navigationTitle("Beacon")
        }
    }
}

struct BeaconAllView: View {
    var body: some View {
        NavigationView {
            Form {
                Text("TEST")
                Text("TEST")
                Text("TEST")
                Text("TEST")
            }
        }.navigationTitle("All Beacon")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct BeaconSpecView: View {
    var body: some View {
        NavigationView {
            Form {
                Text("TEST")
            }
        }.navigationTitle("Specific Beacon")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct BeaconView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconView()
    }
}
