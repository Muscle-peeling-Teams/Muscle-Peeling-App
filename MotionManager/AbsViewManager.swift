//
//  MotionManager.swift
//  MotionManager
//
//  Created by cmStudent on 2022/07/22.
//

import CoreMotion
import SwiftUI
import AVFoundation

final class AbsViewManager: ObservableObject{
    // staticでインスタンスを保持しておく
    // MotionManager.sharedでアクセスができる
    static let shared: AbsViewManager = .init()
    // privateのletでCMMotionManagerインスタンスを作成する
    private let motion = CMMotionManager()
    
    private let queue = OperationQueue()
    
    var backColor = Color.white
    
    // 音声
    private var speechSynthesizer : AVSpeechSynthesizer!
    
    // トレーニングを行えているか
    @Published var trainingSucess = false
    
    var systemImage = "xmark"
    
    // センサーの値
    var x = 0.00
    var y = 0.00
    var z = 0.00
    
    var sensorJudge = true
    
    @Published var trainingCount = 1
    
    var trainingMaxCount = 10
    
    @Published var settingCount = 1
    
    var settingMaxCount = 3
    
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
            }
        }
    }
    
    // カウントダウン
    func startTimer() {
        self.countDown = 5
        self.speeche(text: String(self.countDown))
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            
            self.countDown -= 1
            self.speeche(text: String(self.countDown))
            print("\(self.countDown)")
            if self.countDown <= 0 {
                self.timer?.invalidate()
                self.buttonOpacity.toggle()
                // TODO: 複数対応できるように変更
                self.abs()
            }
        }
    }
    
    // 腹筋
    func abs() {
        speakTimes()
        speeche(text: "体を倒してください")
        startQueuedUpdates()
        
        trainingTime()
    }
    
    // トレーニング（制限時間式）
    func trainingTime() {
        trainingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.systemImage = self.trainingSucess ? "circle":"xmark"
            self.backColor = self.trainingSucess ? Color.white : Color.red
            // 複数対応できるように対応する
            switch(self.sensorJudge){
            case true:
                if self.x >= 0.97 {
                    self.trainingSucess = true
                } else {
                    self.trainingSucess = false
                }
                
            case false:
                if self.x <= 0.02 {
                    self.trainingSucess = true
                    
                } else {
                    self.trainingSucess = false
                }
            }
            if self.trainingCount > self.trainingMaxCount {
                self.settingCount += 1
                if self.settingCount > self.settingMaxCount {
                    self.stopTraining()
                }
                self.motion.stopDeviceMotionUpdates()
                self.pauseTraining()
            }
        }
    }
    
    func pauseTraining() {
        self.motion.stopDeviceMotionUpdates()
        self.trainingTimer?.invalidate()
        self.speakTimer?.invalidate()
        self.stopSpeacTimer?.invalidate()
        self.trainingCount = 0
        self.speeche(text: "終了")
        var pause = 10
        pauseTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            pause -= 1
            if pause <= 5 {
                self.speeche(text: String(pause))
                if pause <= 0 {
                    self.pauseTimer?.invalidate()
                    self.abs()
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
            
            // センサーの範囲に達したら次の範囲に切り替える
            switch(self.sensorJudge){
            case true:
                if self.x >= 0.97 {
                    
                    // TODO: 複数対応できるようにadviceとsucessの部分を配列で読ませる
                    if !self.speechSynthesizer.isSpeaking {
                        self.adviceSensor(sucess: "体を起こしましょう")
                        self.sensorJudge = false
                    }
                }
            case false:
                if self.x <= 0.02 {
                    // TODO: 複数対応できるようにadviceとsucessの部分を配列で読ませる
                    if !self.speechSynthesizer.isSpeaking {
                        self.adviceSensor(sucess: "体を倒しましょう")
                        self.sensorJudge = true
                    }
                }
            }
        }
    }
    // 音声指導
    func adviceSensor(sucess: String) {
        self.speakTimer?.invalidate()
        self.stopSpeacTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            // 複数の値に対応できるようにする
            switch(self.sensorJudge){
            case true:
                self.speeche(text: sucess)
                
                if !self.speechSynthesizer.isSpeaking {
                    self.stopSpeacTimer?.invalidate()
                    self.speakTimes()
                    self.trainingCount += 1
                }
            case false:
                self.speeche(text: sucess)
                
                
                
                
                if !self.speechSynthesizer.isSpeaking {
                    
                    self.stopSpeacTimer?.invalidate()
                    self.speakTimes()
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
        utterance.preUtteranceDelay = 0.0
        speechSynthesizer.speak(utterance)
    }
}

