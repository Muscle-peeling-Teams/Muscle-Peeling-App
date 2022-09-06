//
//  AbsView.swift
//  MotionManager
//
//  Created by 稗田一亜 on 2022/09/06.
//

import SwiftUI

struct AbsView: View {
    @ObservedObject var absViewManager : AbsViewManager
    @Binding var isChanged : Bool
    var body: some View {
        ZStack {
            absViewManager.backColor
                .ignoresSafeArea()
            VStack {
                Spacer()
                Image(systemName:
                        absViewManager.systemImage)
                .resizable()
                .frame(width: 70, height: 70)
                Spacer()
                if (absViewManager.trainingSucess) {
                    Text("\(Int(absViewManager.countDown))")
                        .opacity(absViewManager.buttonOpacity ? 1.0 : 0.0)
                } else {
                    Button("START"){
                        absViewManager.trainingSucess = true
                        absViewManager.startTimer()
                    }
                    .font(.largeTitle)
                    .opacity(absViewManager.buttonOpacity ? 1.0 : 0.0)
                    Button("プランク"){
                        isChanged = false
                    }
                    .font(.largeTitle)
                    .opacity(absViewManager.buttonOpacity ? 1.0 : 0.0)
                }
                Spacer()
                
            }
        }
    }
}
