//
//  ReadyView.swift
//  Muscle-Peeling-App
//
//  Created by cmStudent on 2022/09/16.
//

import SwiftUI

struct ReadyView: View {
    
    //設定時の回数
    @State var count = 10
    //設定時のセット数
    @State var setNum = 3
    //画面遷移に必要なBool型変数
    @State var navigated = false
    
    var body: some View {
        
        VStack(spacing: 30){
            
            Spacer()
            
            // 四角形の描画
            Rectangle()
                .fill(Color.white)
            // 図形の塗りつぶしに使うViewを指定
                .frame(width:300, height:300)
                .overlay(
                    //スワイプによる画面切り替えの実装
                    TabView{
                        Text("あいうえお")
                        //画面下部に表示する文字の部分
                            .tabItem {
                                Text("・")
                            }
                        Text("かきくけこ")
                            .tabItem {
                                Text("・")
                            }
                        Text("さしすせそ")
                            .tabItem {
                                Text("・")
                            }
                    }
                    //スワイプ処理の実装
                        .tabViewStyle(.page)
                    //画面下部に表示する「・」の表示処理部分
                        .indexViewStyle(
                            .page(backgroundDisplayMode: .always)
                        )
                )
                .border(Color.black)
            
            
            // 四角形の描画
            Rectangle()
                .fill(Color.white)
            // 図形の塗りつぶしに使うViewを指定
                .frame(width:300, height: 120)
                .overlay(Text("\(count)回 × \(setNum)セット")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                )
                .border(Color.black)
            
            Spacer()
            
            Button {
                //STARTボタンを押した際の処理
                self.navigated.toggle()
            } label: {
                // 楕円形の描画
                Text("START")
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
            //画面遷移の処理。navigatedの状態変更に合わせて、フルスクリーンでの画面遷移を起こす。
            .fullScreenCover(isPresented: $navigated) {
                //TrainingViewの呼び出し
                TrainingView()
            }
        }
        
        Spacer()
        
    }
}
