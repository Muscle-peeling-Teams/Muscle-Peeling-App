//
//  BackPlankView.swift
//  Muscle-Peeling-App
//
//  Created by cmStudent on 2022/10/18.
//

import SwiftUI

struct BackPlankView: View {
    @StateObject var backplankViewModel: BackPlankViewModel = .shared
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                Text("第\(backplankViewModel.setCount)セット 残り\(Int(backplankViewModel.backplankTime))秒")
                    .font(.largeTitle)
                
                Image("バックプランク")
                    .resizable()
                    .frame(width: 300, height: 300)
                
                HStack(spacing: 30) {
                    if !backplankViewModel.trainingFinish {
                        VStack {
                            Spacer()
                            Text("一時停止")
                            Button(action: {
                                backplankViewModel.pauseTraining()
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
                                backplankViewModel.stopTraining()
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
                            backplankViewModel.trainingFinish = false
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
            backplankViewModel.startTimer()
        }
    }
}

struct BackPlankView_Previews: PreviewProvider {
    static var previews: some View {
        BackPlankView()
    }
}
