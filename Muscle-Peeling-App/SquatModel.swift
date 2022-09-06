//
//  SquatModel.swift
//  Muscle-Peeling-App
//
//  Created by 渡辺幹 on 2022/08/24.
//

import SwiftUI

class SquatModel: ObservableObject {
//    @ObservedObject var motionManager : MotionManager
     var motionManager : MotionManager = MotionManager.shared
    @Published var nowDisp = "select"
    @Published var numInSet = 10
    @Published var setCount = 3
    @Published var count = (remainingSet: 0, remainingCount: 0)
    @Published var timeCountDown = 0
    
    @Published var nowValue = 0.0
    
    @Published var standValue = 0.0
    @Published var loweredValue = 0.0
    
    // 下がり幅の登録
    // 立たせる -> 腰を落とす -> 戻す
    func valueSettingA() {
        motionManager.startQueuedUpdates()
        count = (remainingSet: 1, remainingCount: 0)
        // ガイド(肩幅立ち)
        motionManager.speeche(text: "足を肩幅に開き、スマホの画面を下向きに、持た状態で腕を真っ直ぐ前に出しましょう。")
        
        // 5秒カウント
        timer(time: 15)
        // カウント後に値の取得、設定1
        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
            self.standValue = self.motionManager.x
            self.valueSettingB()
        }
    }
    
    
    func valueSettingB() {
        // ガイド(姿勢を落とす)
        motionManager.speeche(text: "腕を曲げぬよう、ゆっくりと腰を落としましょう。")
        nowDisp = "settingB"
        // 3秒カウント
        timer(time: 15)
        //　カウント後に値の取得、設定2
        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
            self.loweredValue = self.motionManager.x
            //姿勢を戻す
            self.motionManager.speeche(text: "こしをあげてください")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
            self.sitDown()
        }
    }
    
    // 腰を落とす
    func sitDown() {
        // ガイド
        motionManager.speeche(text: "こしをおとしましょう")
        nowDisp = "down"
        // チェック
        checker(process: "down")
    }
    
    // 腰を上げる
    func standUp() {
        // ガイド
        motionManager.speeche(text: "こしをあげましょう")
        nowDisp = "up"
        // チェック
        checker(process: "up")
    }
    
    // クリアチェッカー
    func checker(process: String) {
        nowValue = motionManager.y
        var check = false
        // standValue付近でクリア
        // loweredValue付近でクリア
        if process == "up" {
            if motionManager.y > standValue {
                check = true
            }
        } else if process == "down" {
            if motionManager.y < loweredValue {
                check = true
            }
        }
        if check {
            if process == "up" {
                sitDown()
                couter()
            } else {
                standUp()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.checker(process: process)
            }
        }
    }
    
    // セットカウンター
    func couter() {
        count.remainingCount += 1
        if count.remainingCount == numInSet {
            count.remainingSet += 1
            count.remainingCount = 1
        }
        if count.remainingSet > setCount {
            // 終了
            motionManager.stopTraining()
            nowDisp = "finish"
        }
    }
    
    func timer(time: Int) {
        timeCountDown = time
        for i in 1 ... time {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.timeCountDown -= 1
            }
        }
        
    }
}
