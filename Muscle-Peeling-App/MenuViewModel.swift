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
        var num = 4
        if image == "腕立て" {
            num = 5
        }else if image == "プランク" {
            num = 0
        }else if image == "ブルガリアンスクワット"{
            num = 2
        }else if image == "バックプランク"{
            num = 1

        }else if image == "腹筋"{
            num = 4
        }else{
            //処理なし
        }

        return num
    }
}
