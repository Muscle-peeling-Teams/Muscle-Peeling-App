//
//  BackPlankManager.swift
//  Muscle-Peeling-App
//
//  Created by cmStudent on 2022/09/16.
//

import CoreMotion
import SwiftUI
import AVFoundation

final class BackPlankManager: ObservableObject{
    // staticでインスタンスを保持しておく
    // MotionManager.sharedでアクセスができる
    static let shared: BackPlankManager = .init()
    // privateのletでCMMotionManagerインスタンスを作成する
    private let motion = CMMotionManager()
    
    private let queue = OperationQueue()
    
    var backColor = Color.white
    
    // 音声
    private var speechSynthesizer: AVSpeechSynthesizer!
    
    // トレーニングを行えているか
    @Published var trainingSucess = 0
    @Published var backplankTime = 5.0
    
    var systemImage = "xmark"
    
    // センサーの値
    var x = 0.00
    var y = 0.00
    var z = 0.00
    
    @Published var setCount = 1
    var setMaxCount = 3
    
    // トレーニング時のボタンを透明にする
    @Published var buttonOpacity = true
    
    @Published var countDown = 5
    
    var timer: Timer?
    var trainingTimer: Timer?
    var speakTimer: Timer?
    var stopSpeacTimer: Timer?
    var pauseTimer: Timer?
    
    // シングルトンにするためにinitを潰す
    private init() {}
    
    func startQueuedUpdates() {
        // ジャイロセンサーが使えない場合はこの先の処理をしない
        guard motion.isDeviceMotionAvailable else { return }
        
        // 更新感覚
        motion.deviceMotionUpdateInterval = 6.0 / 60.0 // 0.1秒間隔
        
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
    
    // カウントダウン
    func startTimer() {
        self.countDown = 5
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.countDown -= 1
            print("\(self.countDown)")
            if self.countDown <= 0 {
                self.timer?.invalidate()
                self.buttonOpacity.toggle()
                // TODO: 複数対応できるように変更
                self.backplank()
            }
        }
    }
    
    // バックプランク
    func backplank() {
        speakTimes()
        speeche(text: "スタート")
        startQueuedUpdates()
        
        trainingTime()
    }
    
    // トレーニング（制限時間式）
    func trainingTime() {
        trainingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            print("print\(self.setCount)")
            self.backplankTime -= 0.1
            print("\(self.backplankTime)")
            if self.backplankTime <= 0.0 {
                self.trainingSucess = 2
                if (self.setCount <= self.setMaxCount) {
                    self.pauseTraining()
                } else {
                    self.stopTraining()
                }
            }
        }
        
        
        
    }
    
    func pauseTraining() {
        if trainingSucess == 0 {
            self.speechSynthesizer.pauseSpeaking(at: .word)
            print("一時停止")
            self.trainingTimer?.invalidate()
            self.speakTimer?.invalidate()
            self.stopSpeacTimer?.invalidate()
            speechSynthesizer.pauseSpeaking(at: .word)
            speeche(text: "一時停止します")
            trainingSucess = 1
        } else if trainingSucess == 1 {
            self.speechSynthesizer.pauseSpeaking(at: .word)
            print("再開")
            speechSynthesizer.pauseSpeaking(at: .word)
            speeche(text: "再開します")
            if !speechSynthesizer.isSpeaking {
                backplank()
                trainingSucess = 0
            }
        } else {
            self.motion.stopDeviceMotionUpdates()
            self.trainingTimer?.invalidate()
            self.speakTimer?.invalidate()
            self.stopSpeacTimer?.invalidate()
            speechSynthesizer.pauseSpeaking(at: .word)
            speeche(text: "第\(setCount)セット終了")
            var pause = 10
            pauseTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                pause -= 1
                if pause <= 5 {
                    self.speeche(text: String(pause))
                    if pause <= 0 {
                        self.pauseTimer?.invalidate()
                        self.trainingSucess = 0
                        self.backplankTime = 5.0
                        self.backplank()
                    }
                }
            }
        }
    }
    
    // トレーニング終了
    func stopTraining() {
        // 終了
        self.motion.stopDeviceMotionUpdates()
        self.trainingTimer?.invalidate()
        self.speakTimer?.invalidate()
        self.stopSpeacTimer?.invalidate()
        self.speeche(text: "終了")
        self.buttonOpacity.toggle()
        print("終了")
    }
    
    // 音声作動範囲
    func speakTimes() {
        speakTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if self.x >= -90.0 {
                // TODO: 複数対応できるようにadviceとsucessの部分を配列で読ませる
                self.adviceSensor(advice: "もう少し腰を下げましょう", sucess: "その位置です")
            } else if self.x <= -95.0 {
                // TODO: 複数対応できるようにadviceとsucessの部分を配列で読ませる
                self.adviceSensor(advice: "もう少し腰を上げましょう", sucess: "その位置です")
            }
        }
    }
    
    // 音声指導
    func adviceSensor(advice: String, sucess: String) {
        self.speakTimer?.invalidate()
        self.speeche(text: advice)
        self.stopSpeacTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            // 複数の値に対応できるようにする
            if self.x <= -90.0 && self.x >= -95.0 {
                // 現在音声が動作中か
                if self.speechSynthesizer.isSpeaking {
                    self.speechSynthesizer.pauseSpeaking(at: .word)
                }
                self.speeche(text: sucess)
            }
            if !self.speechSynthesizer.isSpeaking {
                self.stopSpeacTimer?.invalidate()
                self.speakTimes()
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
        utterance.preUtteranceDelay = 0.0
        speechSynthesizer.speak(utterance)
    }
}




