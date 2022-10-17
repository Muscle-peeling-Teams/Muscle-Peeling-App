//
//  menyu.swift
//  MotionManager
//
//  Created by cmStudent on 2022/09/06.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel = MenuViewModel()
    @State var image: String = ""
    @StateObject var settingViewModel: SettingViewModel = .shared
    
    var body: some View {
        
        ZStack{
            ScrollView{
                //横並び
                HStack(spacing: 30){
                    
                    //左側を縦並びに
                    VStack(spacing: 30){
                        
                        Spacer()
                        ForEach(0..<viewModel.leftMenu.count){ number in
                            VStack(spacing: 0){
                                
                                //画像
                                Image("\(viewModel.leftMenu[number])")
                                    .resizable()
                                    .frame(width: 150, height: 200)
                                    .aspectRatio(contentMode: .fit)
                                    .overlay(
                                        //上に名前表示
                                        Text("\(viewModel.leftMenu[number])")
                                            .frame(width: 150, height: 200,alignment: .top)
                                    )
                                
                                //選択ボタン
                                Button(action: {
                                    image = viewModel.leftMenu[number]
                                    viewModel.showingModal.toggle()
                                }){
                                    Text("選択")
                                        .frame(width: 150, height: 50)
                                        .background(Color.yellow)
                                }
                                .fullScreenCover(isPresented: $viewModel.showingModal) {
                                    ReadyView(settingViewModel: settingViewModel, num: viewModel.selectNumber(image: image), image: $image)
                                }
                            }
                            
                        }
                    }
                    //右側を縦並びに
                    VStack(spacing: 30){
                        
                        Spacer()
                        
                        //設定ボタン
                            Image("設定")
                                .resizable()
                                .frame(width: 140, height: 150)
                                .aspectRatio(contentMode: .fit)
                                .overlay(
                                    //上に名前表示
                                    Text("設定")
                                        .frame(width: 150, height: 190,alignment: .top)
                                )
                        
                        //選択ボタン
                        Button(action: {
                            viewModel.SettingModal.toggle()
                        }){
                            Text("選択")
                                .frame(width: 150, height: 50)
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                        }
                        .fullScreenCover(isPresented: $viewModel.SettingModal) {
                            SettingView(viewModel: settingViewModel)
                            }
                                                                        
                        //右側のメニュー
                        ForEach(0..<viewModel.rightMenu.count){ number in
                            VStack(spacing: 0){
                                //画像
                                Image("\(viewModel.rightMenu[number])")
                                    .resizable()
                                    .frame(width: 150, height: 200)
                                    .aspectRatio(contentMode: .fit)
                                    .overlay(
                                        //上に名前表示
                                        Text("\(viewModel.rightMenu[number])")
                                            .frame(width: 150, height: 200,alignment: .top)
                                    )
                                //選択ボタン
                                Button(action: {
                                    image = viewModel.rightMenu[number]
                                    viewModel.showingModal.toggle()
                                }){
                                    Text("選択")
                                        .frame(width: 150, height: 50)
                                        .background(Color.yellow)
                                }
                                .fullScreenCover(isPresented: $viewModel.showingModal) {
                                    ReadyView(settingViewModel: settingViewModel, num: viewModel.selectNumber(image: image), image: $image)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct menyu_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
