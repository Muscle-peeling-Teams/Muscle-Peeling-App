//
//  MotionManager.swift
//  MotionManager
//
//  Created by cmStudent on 2022/07/22.
//

import CoreMotion
import SwiftUI
import AVFoundation

final class MotionManager: ObservableObject{
    // staticでインスタンスを保持しておく
    // MotionManager.sharedでアクセスができる
    static let shared: MotionManager = .init()
    // privateのletでCMMotionManagerインスタンスを作成する
    private let motion = CMMotionManager()
    
    private let queue = OperationQueue()
    
    var backColor = Color.white
    
    private var speechSynthesizer: AVSpeechSynthesizer!
    
    @Published var sensorSucess = false
    
    var systemImage = "xmark"
    
    @Published var x = 0.00
    @Published var y = 0.00
    @Published var z = 0.00
    
    @Published var countDown = 5
    
    var timer: Timer?
    var trainingTimer: Timer?
    var speakTimer: Timer?
    var stopSpeacTimer: Timer?
    
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
        speakTimes()
        var plankTime = 60.0
        speeche(text: "スタート")
        startQueuedUpdates()
        trainingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.systemImage = self.sensorSucess ? "circle":"xmark"
            self.backColor = self.sensorSucess ? Color.white : Color.red
            if self.x <= -0.08 && self.x >= -0.12 {
                self.sensorSucess = true
            } else {
                self.sensorSucess = false
            }
            plankTime -= 0.1
            if plankTime <= 0.0 {
                self.trainingTimer?.invalidate()
                self.speakTimer?.invalidate()
                self.speeche(text: "終了")
            }
        }
    }
    
    func speakTimes() {
        speakTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.x >= -0.08 {
                self.speakTimer?.invalidate()
                self.speeche(text: "もう少し腰を落としましょう")
                self.stopSpeacTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    if !self.speechSynthesizer.isSpeaking {
                        self.stopSpeacTimer?.invalidate()
                        self.speakTimes()
                    }
                }
            }
        }
    }
    
    // 自動音声機能
    func speeche(text: String) {
        // AVSpeechSynthesizerのインスタンス作成
        speechSynthesizer = AVSpeechSynthesizer()
        // 読み上げる、文字、言語などの設定
        let utterance = AVSpeechUtterance(string: text) // 読み上げる文字
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP") // 言語
        utterance.rate = 0.5 // 読み上げ速度
        utterance.pitchMultiplier = 1.0 // 読み上げる声のピッチ
        speechSynthesizer.speak(utterance)
    }
}




