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
    @StateObject var absViewManager: AbsViewManager = .shared
    @State var isChanged = false
    var body: some View {
        if !isChanged {
            PlankView(plankViewManager: plankViewManager, isChanged: $isChanged)
        } else {
            AbsView(absViewManager: absViewManager, isChanged: $isChanged)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

