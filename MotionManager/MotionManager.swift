//
//  MotionManager.swift
//  MotionManager
//
//  Created by cmStudent on 2022/07/22.
//

import Foundation
import CoreMotion

final class MotionManager: ObservableObject{
    // staticでインスタンスを保持しておく
    // MotionManager.sharedでアクセスができる
    static let shared: MotionManager = .init()
    // privateのletでCMMotionManagerインスタンスを作成する
    private let motion = CMMotionManager()
    
    private let queue = OperationQueue()
    
    @Published var x = 0.00
    @Published var y = 0.00
    @Published var z = 0.00
    
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
}
