//
//  ContentView.swift
//  MotionManager
//
//  Created by cmStudent on 2022/07/22.
//

import SwiftUI

struct ContentView: View {
    // MotionManagerのインスタンスを利用する
    @StateObject var plankViewManager: PlankViewManager = .shared
    var body: some View {
        
            PlankView(plankViewManager: plankViewManager)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

