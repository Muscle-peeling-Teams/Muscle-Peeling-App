//
//  AbsView.swift
//  Muscle-Peeling-App
//
//  Created by cmStudent on 2022/09/16.
//

import SwiftUI


struct AbsView: View {
    @StateObject var plankViewManager: MotionManager = .shared
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                Text("第\(plankViewManager.daicount)セット \(plankViewManager.count)回目")
                    .font(.largeTitle)
                
                Image("plank")
                    .resizable()
                    .frame(width: 300, height: 300)
                
                HStack(spacing: 30) {
                    VStack {
                        Spacer()
                        Text("一時停止")
                        Button(action: {
                            plankViewManager.pauseTraining()
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
                            plankViewManager.stopTraining()
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
                    }
                }
            }
        }
        .onAppear{
            plankViewManager.startTimer()
        }
    }
}
