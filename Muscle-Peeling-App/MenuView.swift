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
                HStack(spacing: 30){
                    VStack(spacing: 30){
                        ForEach(0..<viewModel.leftMenu.count){ number in
                            VStack(spacing: 0){
                                
                                
                                Image("\(viewModel.leftMenu[number])")
                                    .resizable()
                                    .frame(width: 150, height: 200)
                                    .aspectRatio(contentMode: .fit)
                                    .overlay(
                                        Text("\(viewModel.leftMenu[number])")
                                            .frame(width: 150, height: 200,alignment: .top)
                                    )
                                
                                Button(action: {
                                    image = viewModel.leftMenu[viewModel.selectNumber(image: viewModel.leftMenu[number])]
                                    viewModel.showingModal.toggle()
                                }){
                                    Text("選択")
                                        .frame(width: 150, height: 50)
                                        .background(Color.yellow)
                                }
                                .fullScreenCover(isPresented: $viewModel.showingModal) {
                                    ReadyView(settingViewModel: settingViewModel, num: number, image: $image)
                                }
                            }
                            
                        }
                    }
                    VStack(spacing: 30){
                        
                        Button(action: {
                            print("Button")
                            viewModel.SettingModal.toggle()
                        }) {
                            RoundedRectangle(cornerRadius: 50)
                                .frame(width: 100, height: 60)
                                .foregroundColor(Color.blue)
                                .overlay(
                                    Text("設定")
                                        .bold()
                                        .padding()
                                        .frame(width: 110, height: 100)
                                        .foregroundColor(Color.black)
                                )
                        }
                        .fullScreenCover(isPresented: $viewModel.SettingModal) {
                            SettingView(viewModel: settingViewModel)
                            }
                        
                        ForEach(0..<viewModel.rightMenu.count){ number in
                            VStack(spacing: 0){
                                
                                
                                Image("\(viewModel.rightMenu[number])")
                                    .resizable()
                                    .frame(width: 150, height: 200)
                                    .aspectRatio(contentMode: .fit)
                                    .overlay(
                                        Text("\(viewModel.rightMenu[number])")
                                            .frame(width: 150, height: 200,alignment: .top)
                                    )
                                
                                Button(action: {
                                    image = viewModel.rightMenu[number]
                                    viewModel.showingModal.toggle()
                                }){
                                    Text("選択")
                                        .frame(width: 150, height: 50)
                                        .background(Color.yellow)
                                }
                                .fullScreenCover(isPresented: $viewModel.showingModal) {
                                    ReadyView(settingViewModel: settingViewModel, num: number, image: $image)
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
