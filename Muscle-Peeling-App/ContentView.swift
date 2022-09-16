//
//  ContentView.swift
//  Muscle-Peeling-App
//
//  Created by 稗田一亜 on 2022/08/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var motionManager : PushUpMotionManager = .shared
    
    var body: some View {
        //PushUpView(motionManager: motionManager)
        ReadyView()
    }
}
