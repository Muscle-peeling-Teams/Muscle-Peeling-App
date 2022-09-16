//
//  PushUp.swift
//  Muscle-Peeling-App
//
//  Created by cmStudent on 2022/09/02.
//


import SwiftUI

struct PushUpView: View {
    @ObservedObject var motionManager : PushUpMotionManager
    
    var body: some View {
        ZStack {
            motionManager.backColor
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("\(motionManager.trainingCount)回目")
                    .frame(width: 70, height: 70)
                
                Spacer()
                
                if (!motionManager.sensorjudge) {
                    Text("\(Int(motionManager.countDown))")
                        .opacity(motionManager.buttonOpacity ? 1.0 : 0.0)
                        .font(.title)
                } else {
                    Button("START"){
                        motionManager.sensorjudge = false
                        motionManager.ready()
                    }
                    .font(.largeTitle)
                    .opacity(motionManager.buttonOpacity ? 1.0 : 0.0)
                }
                Spacer()
                
            }
        }
        .onAppear{
            motionManager.ready()
        }
    }
}
