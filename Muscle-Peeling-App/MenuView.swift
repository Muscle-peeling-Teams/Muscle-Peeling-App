//
//  menyu.swift
//  MotionManager
//
//  Created by cmStudent on 2022/09/06.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel = MenuViewModel()
    
    var body: some View {
        ZStack{
            ScrollView{
                HStack(spacing: 30){
                    VStack(){
                        ForEach(viewModel.leftMenu, id: \.self){ name in
                            VStack(spacing: 0){
                                
                                
                                Image("cat")
                                    .resizable()
                                    .frame(width: 150, height: 200)
                                    .aspectRatio(contentMode: .fit)
                                    .overlay(
                                        Text("\(name)")
                                            .frame(width: 150, height: 200,alignment: .top)
                                    )
                                
                                Button(action: {
                                    print(name)
                                }){
                                    Text("選択")
                                        .frame(width: 150, height: 50)
                                        .background(Color.yellow)
                                }
                            }
                            
                        }
                    }
                    VStack(spacing: 30){
                        
                        Button(action: {
                            print("Button")
                            
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
                        
                        
                        ForEach(viewModel.rightMenu, id: \.self){ name in
                            VStack(spacing: 0){
                                Image("cat")
                                    .resizable()
                                    .frame(width: 150, height: 200)
                                    .aspectRatio(contentMode: .fit)
                                    .overlay(
                                        Text("\(name)")
                                            .frame(width: 150, height: 200,alignment: .top)
                                    )
                                Button(action: {
                                    
                                    print(name)
                                }){
                                    Text("選択")
                                        .frame(width: 150, height: 50)
                                        .background(Color.yellow)
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
