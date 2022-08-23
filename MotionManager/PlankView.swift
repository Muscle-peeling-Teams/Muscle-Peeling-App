//
//  PlankView.swift
//  MotionManager
//
//  Created by 稗田一亜 on 2022/08/21.
//

import SwiftUI

struct PlankView: View {
    @ObservedObject var motionManager : MotionManager  = .shared
    var body: some View {
        ZStack {
            motionManager.backColor
                .ignoresSafeArea()
            VStack {
                Spacer()
                Image(systemName: motionManager.systemImage)
                    .resizable()
                    .frame(width: 70, height: 70)
                Spacer()
                if (motionManager.sensorSucess) {
                    Text("\(motionManager.countDown)")
                } else {
                    Button("START"){
                        motionManager.startTimer()
                    }
                    .font(.largeTitle)
                    .opacity(motionManager.a ? 1.0 : 0.0)
                }
                Spacer()
                
            }
        }
        
    }
}

struct PlankView_Previews: PreviewProvider {
    static var previews: some View {
        PlankView()
    }
}
