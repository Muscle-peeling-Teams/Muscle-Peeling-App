//
//  ContentView.swift
//  MotionManager
//
//  Created by cmStudent on 2022/07/22.
//

import SwiftUI

struct ContentView: View {
    // MotionManagerのインスタンスを利用する
    @StateObject var motionManager: MotionManager = .shared
    
    var body: some View {
        Button("motionManager"){
            motionManager.startQueuedUpdates()
        }
        .font(.title)
        Spacer()
        Text("x: \(String(format: "%.2f",motionManager.x))")
        Spacer()
        Text("y: \(String(format: "%.2f",motionManager.y))")
        Spacer()
        Text("z: \(String(format: "%.2f",motionManager.z))")
        Spacer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

