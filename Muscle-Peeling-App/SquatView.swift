//
//  SquatView.swift
//  Muscle-Peeling-App
//
//  Created by 渡辺幹 on 2022/08/24.
//

import SwiftUI

struct phone {
    static let w = UIScreen.main.bounds.width
    static let h = UIScreen.main.bounds.height
}

struct SquatView: View {
    @StateObject var model = SquatModel()
    let viewList = ["select","settingA","settingB","up","down","finish"]
    var body: some View {
        ZStack {
            
        VStack(spacing: 20) {
            Text("\(model.timeCountDown)    ").frame(width: phone.w, height: 30, alignment: .trailing)
            if model.nowDisp == "select" {
                selectSetView(model: model)
                InstructionTextView(disp: $model.nowDisp)
            } else if model.nowDisp == "finish" {
                SquatImage(disp: $model.nowDisp)
                InstructionTextView(disp: $model.nowDisp)
                Button(action: {
                    model.nowDisp = "settingA"
                }){
                    RoundedRectangle(cornerRadius: 50)
                        .frame(width: 200, height: 60)
                        .foregroundColor(Color.blue)
                        .overlay(
                            Text("ホームへ")
                                .font(.largeTitle)
                                .foregroundColor(Color.white)
                                .fontWeight(.heavy)
                        )
                }
            } else {
                Guide_SquatView(model: model)
            }
            if model.nowDisp == "up" ||  model.nowDisp == "down"{
                HStack(spacing: 50) {
                    Button(action: {
                        
                    }){
                        VStack(spacing: 3) {
                            Text("一時停止")
                                .foregroundColor(Color.black)
                            Circle()
                                .frame(width: phone.w/4, height: phone.w/4)
                                .foregroundColor(Color.gray)
                                .overlay(
                                    Text("||")
                                        .font(.largeTitle)
                                        .fontWeight(.heavy)
                                        .foregroundColor(Color.black)
                                )
                        }
                    }
                    Button(action: {
                        
                    }){
                        VStack(spacing: 3) {
                            Text("中止")
                                .foregroundColor(Color.black)
                            Circle()
                                .frame(width: phone.w/4, height: phone.w/4)
                                .foregroundColor(Color.gray)
                                .overlay(
                                    Text("■")
                                        .font(.largeTitle)
                                        .fontWeight(.heavy)
                                        .foregroundColor(Color.red)
                                )
                        }
                    }
                }
            }
//            HStack {
//                ForEach(viewList, id: \.self){ name in
//                    Button(action: {
//                        model.nowDisp = name
//                    }){
//                        Text("\(name)")
//                            .padding(3)
//                            .border(Color.black)
//                    }
//                }
//            }
        }
            
//            VStack {
//                Text("STAND: \(model.standValue)")
//                Text("SIT: \(model.loweredValue)")
//                Text("NOW: \(model.nowValue)")
//            }
            
        }
    }
}

struct selectSetView: View {
    @StateObject var model: SquatModel
    var body: some View {
        VStack {
            SquatImage(disp: $model.nowDisp)
            HStack {
                Button(action: {
                    if model.setCount > 2 {
                        model.setCount -= 1
                    }
                }){
                    Text("-")
                }
                Text("セット数: \(model.setCount)")
                    .font(.custom("Hiragino Mincho ProN", size: 25))
                Button(action: {
                    model.setCount += 1
                }){
                    Text("+")
                }
            }
            
            HStack {
                Button(action: {
                    if model.numInSet > 2 {
                        model.numInSet -= 1
                    }
                }){
                    Text("-")
                        .fontWeight(.heavy)
                        .font(.title)
                }
                Text("１セット: \(model.numInSet)回")
                    .font(.custom("Hiragino Mincho ProN", size: 25))
                Button(action: {
                    model.numInSet += 1
                }){
                    Text("+")
                        .fontWeight(.heavy)
                        .font(.title)
                }
            }
            
            Button(action: {
                model.nowDisp = "settingA"
            }){
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: 200, height: 60)
                    .foregroundColor(Color.blue)
                    .overlay(
                        Text("START")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .fontWeight(.heavy)
                    )
            }
            
        }
        
    }
}



struct Guide_SquatView: View {
    @StateObject var model: SquatModel
    var body: some View {
        VStack {
            Text("第 \(model.count.remainingSet) セット  \(model.count.remainingCount) 回目")
                .font(.custom("Hiragino Mincho ProN", size: 30))
            SquatImage(disp: $model.nowDisp)
            InstructionTextView(disp: $model.nowDisp)
        }.onAppear(){
            model.valueSettingA()
        }
    }
}

struct SquatImage: View {
    @Binding var disp: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: phone.w*0.7 + 5, height:  phone.w*0.9 + 5)
                .foregroundColor(Color.white)
                .shadow(color: Color.gray, radius: 10, x: 0, y: 0)
            Group {
                if disp == "select" {
                    Image("squat_set").resizable()
                } else if disp == "settingA" || disp == "up"{
                    // 立ってる
                    Image("squat_stand").resizable()
                } else if disp == "settingB" || disp == "down"{
                    // しゃがんでる
                    Image("squat_sit").resizable()
                } else if disp == "finish" {
                    // お疲れ様
                    Image("squat_sit").resizable()
                }
            }.frame(width: phone.w*0.6, height:  phone.w*0.9)
        }
    }
}

struct InstructionTextView: View {
    @Binding var disp: String
    var body: some View {
        Group {
            if disp == "select" {
                Text("1セットあたりの回数と、行うセット数を選んでください。\nスマホを装着してSTARTを押し、指示を待ちましょう。")
            } else if disp == "settingA"{
                Text("足を肩幅に開いて腕を真っ直ぐに伸ばし、キープしてください。")
            } else if disp == "up"{
                Text("腕を曲げぬよう、ゆっくりと腰を上げ、足を伸ばしましょう！")
            } else if disp == "settingB" {
                Text("そのままの体制で腰を落とし、体制をキープしてください。")
            } else if disp == "down"{
                Text("そのままの体制で腰を落としましょう！")
            } else if disp == "finish" {
                Text("お疲れさまでした！")
            }
        }.font(.custom("Hiragino Mincho ProN", size: 15))
    }
}


struct SquatView_Previews: PreviewProvider {
    static var previews: some View {
        SquatView()
    }
}
