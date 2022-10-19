//
//  AbsView.swift
//  Muscle-Peeling-App
//
//  Created by cmStudent on 2022/09/16.
//

import SwiftUI


struct AbsView: View {
    @StateObject var plankViewManager: MotionManager = .shared
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                Text("第\(plankViewManager.daicount)セット \(plankViewManager.count)回目")
                    .font(.largeTitle)
                
                Image("腹筋")
                    .resizable()
                    .frame(width: 300)
                
                
                
            
                if plankViewManager.kairosu == 0{
                    
                    
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
                }else{
                    Button {
                        dismiss()
                        plankViewManager.kairosu = 0
                        
                        
                        
                    } label: {
                        // 楕円形の描画
                            Text("お疲れ様です")
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
        .onAppear{
            plankViewManager.startTimer()
        }
    }
}

struct ConentView_Previews: PreviewProvider {
    static var previews: some View {
        AbsView()
    }
}
