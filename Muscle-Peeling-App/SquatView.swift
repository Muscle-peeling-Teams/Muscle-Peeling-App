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
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct InstructionTextView: View {
    @State var text: String
    var body: some View {
        Text(text)
    }
}

struct Reserve_SquatView: View {
    var body: some View {
        VStack {
            Image("squat_stand")
            InstructionTextView(text: InstructionTexts.squat_stand)
        }
    }
}

struct Stand_SquatView: View {
    var body: some View {
        VStack {
            Image("squat_stand")
            InstructionTextView(text: InstructionTexts.squat_stand)
        }
    }
}

struct Up_SquatView: View {
    var body: some View {
        Image("squat_stand")
        InstructionTextView(text: InstructionTexts.squat_up)
    }
}

struct Down_SquatView: View {
    var body: some View {
        Image("squat_sit")
        InstructionTextView(text: InstructionTexts.squat_down)
    }
}

struct Finish_SquatView: View {
    var body: some View {
        Image("squat_stand")
        InstructionTextView(text: InstructionTexts.squat_finish)
    }
}

struct InstructionTexts {
    static let squat_reserve = "1セットあたりの回数と、行うセット数を選んでください。"
    static let squat_stand = "スマホを画面を下に向けて持ち、足を肩幅に開いて腕を真っ直ぐに伸ばしましょう！"
    static let squat_up = "腕を曲げぬよう、ゆっくりと腰を上げ、足を伸ばしましょう！"
    static let squat_down = "腕を曲げぬよう、ゆっくりと腰を落としましょう！"
    static let squat_finish = "お疲れさまでした！"
}

struct SquatView_Previews: PreviewProvider {
    static var previews: some View {
        SquatView()
    }
}
