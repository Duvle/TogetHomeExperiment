//
//  SplashScreenView.swift
//  TogetHomeExperiment
//
//  Created by IT DICE on 2023/04/01.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var time = 2.0
    
    var body: some View {
        if isActive {
            ContentView()
        }
        else {
            Color("BackgroundColor")
                .ignoresSafeArea()
                .overlay{
                    VStack{
                        Spacer()
                        VStack{
                            Image("TogetHomeHLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                            Text("Experiment Service")
                                .font(.custom("SamsungOneKorean-300", size: 15))
                                .padding(.top, 10)
                        }.padding(.top, 50)
                        Spacer()
                        HStack{
                            Text("Powered By ")
                                .font(.custom("SamsungOneKorean-700", size: 17))
                            Image("ITDICELogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width:150, height: 30)
                        }.padding(.bottom, 70)
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
