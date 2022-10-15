//
//  MenuViewModel.swift
//  Muscle-Peeling-App
//
//  Created by 稗田一亜 on 2022/09/14.
//

import Foundation

class MenuViewModel: ObservableObject {
    @Published var showingModal = false
    @Published var SettingModal = false
    let leftMenu = ["プランク","ブルガリアンスクワット","腹筋"]
    let rightMenu = ["バックプランク","腕立て"]
    
    func selectNumber(image: String)-> Int{
        var num = 0
        if image == "プランク" {
            num = 0
        } else if image == "バッグプランク" {
            num = 1
        } else {
            
        }
        return num
    }
}
