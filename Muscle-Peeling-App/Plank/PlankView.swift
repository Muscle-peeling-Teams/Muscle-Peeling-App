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
        ZStack{
            VStack{
                Spacer()
                Text("第\(plankViewManager.setCount)セット 残り\(Int(plankViewManager.plankTime))秒")
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
