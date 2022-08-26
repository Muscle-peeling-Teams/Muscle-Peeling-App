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
    
    var standValue = 0.0
    var loweredValue = 0.0
    
    // 下がり幅の登録
    // 立たせる -> 腰を落とす -> 戻す
    func valueSetting() {
        
    }
    
    // 腰を落とす
    func sitDown() {
        
    }
    
    // 腰を上げる
    func standUp() {
        
    }
    
    // クリアチェッカー
    func checker() {
        
    }
    
    // セットカウンター
    func couter() {
        
    }
}
