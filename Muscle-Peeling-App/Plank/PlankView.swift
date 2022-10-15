//
//  PlankView.swift
//  PlankViewManager
//
//  Created by 稗田一亜 on 2022/08/21.
//

import SwiftUI

struct PlankView: View {
    @StateObject var plankViewModel: PlankViewModel = .shared
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                Text("第\(plankViewModel.setCount)セット 残り\(Int(plankViewModel.plankTime))秒")
                    .font(.largeTitle)
                
                Image("プランク")
                    .resizable()
                    .frame(width: 300, height: 300)
                
                HStack(spacing: 30) {
                    if !plankViewModel.trainingFinish {
                        VStack {
                            Spacer()
                            Text("一時停止")
                            Button(action: {
                                plankViewModel.pauseTraining()
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
                                plankViewModel.stopTraining()
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
                    } else {
                        Button {
                            dismiss()
                            dismiss()
                        } label: {
                            // 楕円形の描画
                            Text("お疲れさまです")
                                .font(.largeTitle)
                                .frame(width: 360, height: 100)
                                .foregroundColor(Color(.black))
                                .background(Color(.white))
                                .cornerRadius(24)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 1000)
                                        .stroke(Color(.black), lineWidth: 1.0)
                                )
                        }
                    }
                }
            }
        }
        .onAppear{
            plankViewModel.startTimer()
        }
    }
    
}

struct PlankView_Previews: PreviewProvider {
    static var previews: some View {
        PlankView()
    }
}

