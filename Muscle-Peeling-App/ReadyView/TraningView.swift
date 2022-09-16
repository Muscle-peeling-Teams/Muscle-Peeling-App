//
//  ReadyView.swift
//  Muscle-Peeling-App
//
//  Created by cmStudent on 2022/09/16.
//

import SwiftUI

struct TrainingView: View {
    
    @State var nowCount = 0
    @State var nowSet = 0
    @State var finishbtn = false
    @State var menuShiftFlag = false
    
    var body: some View {
        VStack{
            Spacer()
            Text("第\(nowSet)セット \(nowSet)回目")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            // 四角形の描画
            Rectangle()
                .fill(Color.white)
            // 図形の塗りつぶしに使うViewを指定
                .frame(width:300, height:300)
                .overlay(
                    //スワイプによる画面切り替えの実装
                    //ユーザーが見ない可能性が大きいが、フォーム案内
                    TabView{
                        VStack{
                            Text("背中から足までを真っ直ぐ保ちましょう")
                            Image("pushup1")
                                .resizable()
                                .scaledToFit()
                                .tabItem {
                                    Text("・")
                                }
                        }
                        
                        VStack{
                            Text("お尻の高さを維持しましょう")
                            Image("pushup2")
                                .resizable()
                                .scaledToFit()
                                .tabItem {
                                    Text("・")
                                }
                        }
                    }
                    //スワイプ処理の実装
                        .tabViewStyle(.page)
                    //画面下部に表示する「・」の部分
                        .indexViewStyle(
                            .page(backgroundDisplayMode: .always)
                        )
                )
                .border(Color.black)
            
            Spacer()
            
            if finishbtn == false{
                
                HStack(spacing: 120){
                    
                    VStack(spacing:60){
                        Text("一時停止")
                            .font(.title2)
                        
                        Button {
                            //一時停止ボタンの処理
                        } label: {
                            
                            Text("I I")
                                .foregroundColor(Color.black)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .background(Circle()
                                    .fill(Color.yellow)
                                    .frame(width:150, height:150))
                        }
                    }
                    
                    VStack(spacing:60){
                        Text("中止")
                            .font(.title2)
                        
                        Button {
                            //中止ボタンの処理
                            finishbtn = true
                        } label: {
                            
                            Text("■")
                                .foregroundColor(Color.black)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .background(Circle()
                                    .fill(Color.red)
                                    .frame(width:150, height:150))
                        }
                    }
                }
                
            }else{
                //設定したセット数などが終わった後の、終了画面への切り替え
                
                Button {
                    //テスト段階ではReadyViewに戻るようにコーディング
                    menuShiftFlag = true
                    
                } label: {
                    Text("お疲れ様でした。")
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
                .fullScreenCover(isPresented: $menuShiftFlag) {
                    //TrainingViewの呼び出し
                    ReadyView()
                }
            }
            Spacer()
        }
    }
}


