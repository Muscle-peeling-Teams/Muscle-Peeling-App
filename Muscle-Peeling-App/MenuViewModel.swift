//
//  MenuViewModel.swift
//  Muscle-Peeling-App
//
//  Created by 稗田一亜 on 2022/09/14.
//

import Foundation

class MenuViewModel: ObservableObject {
    @Published var showingModal = false
    let leftMenu = ["プランク","ブルガリアンスクワット","腹筋"]
    let rightMenu = ["バックプランク","スクワット","腕立て"]
    
    let leftImage = ["plank", "bulgarian squat","abs"]
    let rightImage = ["back", "squat", "pushup"]
}
