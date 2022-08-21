//
//  MotionManager.swift
//  MotionManager
//
//  Created by cmStudent on 2022/07/22.
//

import CoreMotion
import SwiftUI

final class MotionManager: ObservableObject{
    // staticでインスタンスを保持しておく
    // MotionManager.sharedでアクセスができる
    static let shared: MotionManager = .init()
    // privateのletでCMMotionManagerインスタンスを作成する
    private let motion = CMMotionManager()
    
    private let queue = OperationQueue()
    
    @Published var backColor = Color.white
    
    @Published var sensorSucess = false
    
    @Published var systemImage = "xmark"
    
    @Published var x = 0.00
    @Published var y = 0.00
    @Published var z = 0.00
    
    @Published var countDown = 5
    
    var timer: Timer?
    
    // シングルトンにするためにinitを潰す
    private init() {}
    
    func startQueuedUpdates() {
        // ジャイロセンサーが使えない場合はこの先の処理をしない
        guard motion.isGyroAvailable else { return }
        
        // 更新感覚
        motion.gyroUpdateInterval = 6.0 / 60.0 // 0.1秒間隔
        
        // 加速度センサーを利用して値を取得する
        // 取ってくるdataの型はCMAcccerometterData?になっている
        motion.startDeviceMotionUpdates(to: queue) { data, error in
            // dataはオプショナル型なので、安全に取り出す
            if let validData = data {
                DispatchQueue.main.async {
                    self.x = validData.gravity.x
                    self.y = validData.gravity.y
                    self.z = validData.gravity.z
                }
            
                print("x: \(self.x)")
                print("y: \(self.y)")
                print("z: \(self.z)")
            }
        }
    }
    
    func startTimer() {
        sensorSucess = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.countDown -= 1
            print("\(self.countDown)")
            if self.countDown <= 0 {
                self.timer?.invalidate()
                // TODO:複数対応できるように変更
                self.plank()
            }
        }
    }
    
    func plank() {
        startQueuedUpdates()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.systemImage = self.sensorSucess ? "circle":"xmark"
            self.backColor = self.sensorSucess ? Color.white : Color.red
            // TODO: 他の分岐方法を考える
            if self.x <= -0.08 && self.x >= -0.12 {
                if self.y <= 1.00 && self.y >= 0.98 || self.y >= -1.00 && self.y <= -0.98 {
                    self.sensorSucess = true
                } else {
                    self.sensorSucess = false
                }
            } else {
                self.sensorSucess = false
            }
        }
    }
}
