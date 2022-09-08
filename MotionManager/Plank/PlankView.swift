//
//  PlankView.swift
//  PlankViewManager
//
//  Created by 稗田一亜 on 2022/08/21.
//

import SwiftUI

struct PlankView: View {
    @ObservedObject var plankViewManager : PlankViewManager
    var body: some View {
        ZStack {
            plankViewManager.backColor
                .ignoresSafeArea()
            VStack {
                Spacer()
                Image(systemName:
                    plankViewManager.systemImage)
                    .resizable()
                    .frame(width: 70, height: 70)
                Spacer()
                if (plankViewManager.trainingSucess) {
                    Text("\(Int(plankViewManager.countDown))")
                        .opacity(plankViewManager.buttonOpacity ? 1.0 : 0.0)
                } else {
                    Button("START"){
                        plankViewManager.trainingSucess = true
                        plankViewManager.startTimer()
                    }
                    .font(.largeTitle)
                    .opacity(plankViewManager.buttonOpacity ? 1.0 : 0.0)
                }
                Spacer()
                
            }
        }
        
    }
}
