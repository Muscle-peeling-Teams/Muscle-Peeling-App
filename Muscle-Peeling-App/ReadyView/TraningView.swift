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
                        Text("あいうえお")
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
                    //画面下部に表示する「・」の部分
                        .indexViewStyle(
                            .page(backgroundDisplayMode: .always)
                        )
                )
                .border(Color.black)
            
            Spacer()
            
            HStack(spacing: 120){
                VStack(spacing:60){
                    Text("一時停止")
                        .font(.title2)
                    
                    Button {
                        //一時停止ボタンの処理
                    } label: {
                        
                    Text("I I")
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
                    } label: {
                        
                    Text("■")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .background(Circle()
                                        .fill(Color.red)
                                        .frame(width:150, height:150))
                    }
                }
            }
            Spacer()
        }
    }
}

struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingView()
    }
}
