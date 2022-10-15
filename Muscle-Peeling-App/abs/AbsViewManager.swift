//
//  File.swift
//  Muscle-Peeling-App
//
//  Created by cmStudent on 2022/09/16.
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
    
    // 音声
    private var speechSynthesizer: AVSpeechSynthesizer!
    
    // トレーニングを行えているか
    @Published var trainingSucess = 3
    
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
    @Published var count = 0
    
    var maxcount = 10
    var setcount = 1
    var maxsetcount = 3
    
    
    
    // シングルトンにするためにinitを潰す
    private init() {}
    
    
    func fukkinncount(){
        
        
            
            
        }

    
    
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
        self.speeche(text: String(self.countDown))
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            
            self.countDown -= 1
            self.speeche(text: String(self.countDown))
            print("\(self.countDown)")
            if self.countDown <= 0 {
                self.timer?.invalidate()
                self.buttonOpacity.toggle()
                // TODO: 複数対応できるように変更
                self.plank()
            }
        }
    }
    
    
   
    
    // プランク
    func plank() {
        trainingSucess = 0
        speakTimes(x: 1)
        speeche(text: "スタート")
        startQueuedUpdates()
        
        trainingTime()
    }
    
    // トレーニング（制限時間式）
    func trainingTime() {
        trainingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if self.count >= self.maxcount {
                self.trainingSucess = 2
                self.setcount += 1
                if (self.setcount <= self.setMaxCount) {
                    self.pauseTraining()
                } else {
                    self.stopTraining()
                }
            }
        }
    }
    
    // トレーニング終了
    func stopTraining() {
        trainingSucess = 3
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
    func speakTimes(x: Int) {
        
        
        speakTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            
            switch(x){
            case 1:
                if self.x >= 0.97 {
                    
                    // TODO: 複数対応できるようにadviceとsucessの部分を配列で読ませる
                    self.adviceSensor(advice: "", sucess: "体を起こしましょう", x: x)
                 
                    
                   
                }
            case 2:
                if self.x <= 0.02 {
                    
                    
                    // TODO: 複数対応できるようにadviceとsucessの部分を配列で読ませる
                    self.adviceSensor(advice: "", sucess: "体を倒しましょう", x: x)
             
                   
                }
            default:
                break;
            }
        
        }
    }
    
    // 音声指導
    func adviceSensor(advice: String, sucess: String, x: Int) {
        self.speakTimer?.invalidate()
        self.speeche(text: advice)
        self.stopSpeacTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            // 複数の値に対応できるようにする
            switch(x){
            case 1:
                print("ga")
                var x = 1
                    self.fukkinncount()
                    self.speeche(text: sucess)
                self.count += 1
                  
                    x = 2
                
                if !self.speechSynthesizer.isSpeaking {
                    self.stopSpeacTimer?.invalidate()
                    self.speakTimes(x: x)
                    
                }
            case 2:
                print("yeah")
                var x = 2
                self.speeche(text: sucess)
                
                x = 1
                
                
                if !self.speechSynthesizer.isSpeaking {
                    
                    self.stopSpeacTimer?.invalidate()
                    self.speakTimes(x: x)
                }
            default:
                break;
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
                plank()
                trainingSucess = 0
            }
        } else if trainingSucess == 2{
            count = 0
            self.motion.stopDeviceMotionUpdates()
            self.trainingTimer?.invalidate()
            self.speakTimer?.invalidate()
            self.stopSpeacTimer?.invalidate()
            speechSynthesizer.pauseSpeaking(at: .word)
            speeche(text: "第\(setcount)セット終了")
            var pause = 10
            pauseTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                pause -= 1
                if pause <= 5 {
                    self.speeche(text: String(pause))
                    if pause <= 0 {
                        self.pauseTimer?.invalidate()
                        self.trainingSucess = 0
                        self.plank()
                    }
                }
            }
        } else {
            
        }
    }
}
