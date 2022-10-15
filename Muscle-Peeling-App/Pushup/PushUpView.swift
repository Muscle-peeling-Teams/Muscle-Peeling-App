
//
//  PushUp.swift
//  Muscle-Peeling-App
//
//  Created by cmStudent on 2022/09/02.
//


import SwiftUI

struct PushUpView: View {
    @ObservedObject var motionManager : PushUpMotionManager = .shared
    @State var shiftMenu = false
    
    var body: some View {
        
        ZStack{
            VStack{
                Spacer()
                Text("第\(motionManager.trainingSetCount)セット 残り\(Int((motionManager.settingCount) - (motionManager.trainingCount)))回")
                    .font(.largeTitle)
                
                Image("plank")
                    .resizable()
                    .frame(width: 300, height: 300)
                
                HStack(spacing: 30) {
                    VStack {
                        Spacer()
                        Text("一時停止")
                        Button(action: {
                            if motionManager.trainingFinished == false{
                                motionManager.pauseTraining()
                            }else{
                                //終了時には反応させない
                            }
                        }) {
                            Text("| |")
                                .font(.largeTitle)
                                .bold()
                                .padding()
                                .frame(width: 100, height: 100)
                            
                                .foregroundColor(Color.black)
                                .overlay(
                                    Circle()
                                        .stroke(Color.yellow, lineWidth: 3)
                                )
                        }
                        Spacer()
                    }
                    VStack {
                        Text("中止")
                        Button(action: {
                            motionManager.stopTraining()
                            shiftMenu.toggle()
                        }) {
                            Text("■")
                                .font(.largeTitle)
                                .bold()
                                .padding()
                                .frame(width: 100, height: 100)
                            
                                .foregroundColor(Color.black)
                                .overlay(
                                    Circle()
                                        .stroke(Color.red, lineWidth: 3)
                                )
                        }
                        .fullScreenCover(isPresented: $shiftMenu) {
                            MenuView()
                        }
                    }
                }
            }
        }
        .onAppear{
            motionManager.trainingFinished = false
            motionManager.trainingCount = 1
            motionManager.trainingSetCount = 1
            motionManager.ready()
        }
    }
}

        
        
//        ZStack {
//            motionManager.backColor
//                .ignoresSafeArea()
//            VStack {
//                Spacer()
//                Text("\(motionManager.trainingCount)回目")
//                    .frame(width: 70, height: 70)
//
//                Spacer()
//
//                if (!motionManager.sensorjudge) {
//                    Text("\(Int(motionManager.countDown))")
//                        .opacity(motionManager.buttonOpacity ? 1.0 : 0.0)
//                        .font(.title)
//
//                    Spacer()
//                } else {
//
//                    if motionManager.finishActionButton == false{
//                        Button("START"){
//                            motionManager.sensorjudge = false
//                            motionManager.ready()
//                        }
//                        .font(.largeTitle)
//                        .opacity(motionManager.buttonOpacity ? 1.0 : 0.0)
//                    }else{
//                        Button("メニューへ戻る"){
//                            shiftMenu.toggle()
//                        }
//                        .font(.largeTitle)
//                        .fullScreenCover(isPresented: $shiftMenu) {
//                            MenuView()
//                        }
//                    }
//                    Spacer()
//                }
//            }
//        }
//    }
//}
