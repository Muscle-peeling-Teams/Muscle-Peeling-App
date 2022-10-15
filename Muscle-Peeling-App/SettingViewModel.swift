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
    @Published var set = [2,2,2,2,2,2]
    @Published var play = [59,59,9,9,9,9]
    
    func SetTraining(num: Int) -> Int {
         return selectedSet[num]
    }
    
    func CountTraining(num: Int) -> Int {
        return selectedPlay[num]
    }
}
