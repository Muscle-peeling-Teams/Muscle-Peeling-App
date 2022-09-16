//
//  BackPlankView.swift
//  Muscle-Peeling-App
//
//  Created by cmStudent on 2022/09/16.
//

import SwiftUI

struct BackPlankView: View {
    @ObservedObject var backManager : BackPlankManager
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                Text("第\(backManager.setCount)セット 残り\(Int(backManager.backplankTime))秒")
                    .font(.largeTitle)
                
                Image("plank")
                    .resizable()
                    .frame(width: 300, height: 300)
                
                HStack(spacing: 30) {
                    VStack {
                        Spacer()
                        Text("一時停止")
                        Button(action: {
                            backManager.pauseTraining()
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
                            backManager.stopTraining()
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
            backManager.startTimer()
        }
    }
}
