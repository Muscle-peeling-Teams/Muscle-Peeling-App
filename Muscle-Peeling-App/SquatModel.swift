//
//  SquatModel.swift
//  Muscle-Peeling-App
//
//  Created by 渡辺幹 on 2022/08/24.
//

import SwiftUI

class SquatModel: ObservableObject {
    @Published var numInSet = 10
    @Published var setCount = 3
    @Published var count = (remainingSet: 0, remainingCount: 0)
    @Published var timeCountDown = 0
    
    var standValue = 0.0
    var loweredValue = 0.0
    
    // 下がり幅の登録
    // 立たせる -> 腰を落とす -> 戻す
    func valueSetting() {
        count = (remainingSet: setCount, remainingCount: numInSet)
        // ガイド(肩幅立ち)
        // 3秒カウント
        timer(time: 3)
        // 値の取得、設定1
        
        // ガイド(姿勢を落とす)
        // 3秒カウント
        timer(time: 3)
        //　値の取得、設定2
        
        // 姿勢を戻す
    }
    
    // 腰を落とす
    func sitDown() {
        // ガイド
        // チェック
        // 腰を上げる
    }
    
    // 腰を上げる
    func standUp() {
        // ガイド
        // チェック
        // カウント
        // 腰を下げる
    }
    
    // クリアチェッカー
    func checker() {
        // standValue付近でクリア
        // loweredValue付近でクリア
    }
    
    // セットカウンター
    func couter() {
        count.remainingCount -= 1
        if count.remainingCount < 1 {
            count.remainingSet -= 1
            count.remainingCount = numInSet
        }
        if count.remainingSet < 1 {
            // 終了
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
