//
//  SettingViewModel.swift
//  Muscle-Peeling-App
//
//  Created by 稗田一亜 on 2022/09/14.
//

import Foundation

class SettingViewModel: ObservableObject {
    private init() {}
    static let shared: SettingViewModel = .init()
    @Published var selectedSet = [2,2,2,2,2,2]
    @Published var selectedPlay = [59,59,9,9,9,9]
    @Published var set = [3,3,3,3,3,3]
    @Published var play = [60,60,10,10,10,10]
    
    func SetTraining(num: Int) -> Int {
         return set[num]
    }
    
    func CountTraining(num: Int) -> Int {
        return play[num]
    }
}
