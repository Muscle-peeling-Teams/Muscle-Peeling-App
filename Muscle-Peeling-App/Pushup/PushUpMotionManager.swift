//
//  MotionManager.swift
//  Muscle-Peeling-App
//
//  Created by cmStudent on 2022/08/30.
//

import CoreMotion
import SwiftUI
import AVFoundation

final class PushUpMotionManager: ObservableObject{
    //staticでインスタンスを保持しておく
    //MotionManager.sharedでアクセスができる
    static let shared: PushUpMotionManager = .init()
    //privateのletでCMMotionManagerインスタンスを作成する
    private let motion = CMMotionManager()
    private let queue = OperationQueue()
    var backColor = Color.white
    //音声
    private var speechSynthesizer: AVSpeechSynthesizer!
    //トレーニングの上下判定
    @Published var sensorjudge = true
    //トレーニングの成功、一回の成功
    @Published var trainingSucess = false
    //トレーニングの現在の回数
    @Published var trainingCount = 1
    //トレーニングの現在のセット数
    @Published var trainingSetCount = 1
    //トレーニングの回数設定(テストでは3)
    @Published var settingCount = 10
    //トレーニングの設定セット数
    @Published var settingSetCount = 3
    //スタートまでのカウントダウン
    @Published var countDown = 5
    // トレーニング時のボタンを透明にする
    @Published var buttonOpacity = true
<<<<<<< HEAD
    //トレーニング終了判定
    @Published var trainingFinished = false
    //メニューへ戻るボタンの表示判定
    @Published var finishActionButton = false
    //一時停止用の判定変数
    @Published var pauseNum = 3
=======
    //Pushup用の画像を変数に含める(受け渡しがうまく行かず現在未使用。設定用のクラスとかに収める可能性大)
    @Published var pushupImage1 = "pushup1"
    @Published var pushupImage2 = "pushup2"
    //Pushup用の説明を変数に含める(受け渡しがうまく行かず現在未使用。設定用のクラスとかに収める可能性大)
    @Published var pushupTalk1 = "下の図の場所に装着してください"
    @Published var pushupTalk2 = "背中から足までを真っ直ぐ保ちましょう"
    @Published var pushupTalk3 = "お尻の高さを維持しましょう"
>>>>>>> e188086 (0917_終了画面への処理を追加)
    
    // センサーの値
    var x = 0.00
    var y = 0.00
    var z = 0.00
    
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
        
        // 更新感覚(0.1秒間隔)
        motion.deviceMotionUpdateInterval = 6.0 / 60.0
        
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
    
    func ready(){
        self.countDown = 5
        self.speeche(text: String(self.countDown))
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] _ in
            
            self.countDown -= 1
            if self.countDown > 0 {
                self.speeche(text: String(self.countDown))
            }
            print("\(self.countDown)")
            
            if self.countDown <= 0 {
                self.timer?.invalidate()
                self.buttonOpacity.toggle()
                self.pushUpStart()
            }
        }
    }
    
    // 腕立て
    func pushUpStart() {
        trainingCount = 1
        pauseNum = 0
        speakTimes(SensorJudge:sensorjudge)
        speeche(text: "はじめてください")
        startQueuedUpdates()
        pushUpCount()
    }
    
    //一時停止からの再開処理
    func pauseRestart(){
        speechSynthesizer.pauseSpeaking(at: .word)
        self.speechSynthesizer.pauseSpeaking(at: .word)
        self.speakTimes(SensorJudge:self.sensorjudge)
        self.speeche(text: "再開してください")
        self.pauseTimer?.invalidate()
        self.sensorjudge = false
        self.startQueuedUpdates()
        self.pushUpCount()
        
//        時間制の休憩は廃止
//        var pauseTime = 10
//        pauseTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){_ in
//            pauseTime -= 1
//
//            if pauseTime <= 5 {
//                if pauseTime > 0 {
//                    self.speeche(text: String(pauseTime))
//                }
//
//                if pauseTime <= 0{
//                    self.speechSynthesizer.pauseSpeaking(at: .word)
//                    self.speakTimes(SensorJudge:self.sensorjudge)
//                    self.speeche(text: "再開してください")
//                    self.pauseTimer?.invalidate()
//                    self.sensorjudge = false
//                    self.startQueuedUpdates()
//                    self.pushUpCount()
//                }
//            }
//        }
    }
    
    // トレーニング（回数式）
    func pushUpCount() {
        trainingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){_ in
            switch(self.sensorjudge){
                
            case true:
                if self.x >= 0.5{
                    self.trainingSucess = true
                }else{
                    self.trainingSucess = false
                }
                
            case false:
                if self.x <= -0.5{
                    self.trainingSucess = true
                    
                }else{
                    self.trainingSucess = false
                }
            }
        }
    }
    
    //1セット終了時のアクション
    func pauseAction(){
        pauseNum = 3
        self.motion.stopDeviceMotionUpdates()
        self.trainingTimer?.invalidate()
        self.speakTimer?.invalidate()
        self.stopSpeacTimer?.invalidate()
        self.speeche(text: "休憩してください、休憩時間30秒です")
        var pauseTime = 30
        
        pauseTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){_ in
            pauseTime -= 1
            
            if pauseTime <= 5 {
                if pauseTime > 0 {
                    self.speeche(text: String(pauseTime))
                }
                
                if pauseTime <= 0{
                    self.pauseTimer?.invalidate()
                    self.sensorjudge = false
                    pauseTime = 0
                    self.pushUpStart()
                }
            }
        }
    }
    
    //一時停止時のアクション
    func pauseTraining(){
        speechSynthesizer.pauseSpeaking(at: .word)
        if pauseNum == 0 {
            pauseNum = 1
            speechSynthesizer.pauseSpeaking(at: .word)
            print("一時停止")
            self.trainingTimer?.invalidate()
            self.speakTimer?.invalidate()
            self.stopSpeacTimer?.invalidate()
            speeche(text: "一時停止します、再開する場合は再度このボタンを押してください")
            print(pauseNum)
            
        } else if pauseNum == 1 {
            pauseNum = 0
            speechSynthesizer.pauseSpeaking(at: .word)
            print("再開")
            if !speechSynthesizer.isSpeaking {
                speechSynthesizer.pauseSpeaking(at: .word)
            }
            pauseRestart()
            print(pauseNum)
        }
    }
    
    // トレーニング終了
    func stopTraining() {
        // 終了
        speechSynthesizer.pauseSpeaking(at: .word)
        self.motion.stopDeviceMotionUpdates()
        self.trainingTimer?.invalidate()
        self.speakTimer?.invalidate()
        self.stopSpeacTimer?.invalidate()
        self.speeche(text: "中止してメニューに戻ります")
        self.buttonOpacity.toggle()
        print("中止")
        //finishActionButton = true
        trainingFinished = true
    }
    
    func finishTraining(){
        // 終了
        speechSynthesizer.pauseSpeaking(at: .word)
        self.motion.stopDeviceMotionUpdates()
        self.trainingTimer?.invalidate()
        self.speakTimer?.invalidate()
        self.stopSpeacTimer?.invalidate()
        self.speeche(text: "終了です、お疲れ様でした")
        self.buttonOpacity.toggle()
        print("終了")
        //finishActionButton = true
        trainingFinished = true
    }
    
    // 音声作動範囲
    //sucess判定は腕立てでいる？腰が浮いてるとかの判定？
    func speakTimes(SensorJudge: Bool) {
        
        speakTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            
            switch(self.sensorjudge){
                
            case true:
                
                if self.x >= 0.5{
                    //現在の回数(init:0) > 設定回数(test:3)
                    if self.trainingCount >= self.settingCount{
                        //現在のセット数と設定セット数の比較
                        if self.trainingSetCount >= self.settingSetCount{
                            self.finishTraining()
                            
                        }else{
                            self.trainingSetCount += 1
                            self.motion.stopDeviceMotionUpdates()
                            self.pauseAction()
                        }
                        
                    } else {
                        self.adviceSensor(sucess: "\(self.trainingCount)回、下げてください", sensorJudge: self.sensorjudge)
                        self.sensorjudge = false
                    }
                }
                
            case false:
                if self.x <= -0.5{
                    self.adviceSensor(sucess: "あげてください", sensorJudge: self.sensorjudge)
                    self.sensorjudge = true
                }
            }
        }
    }
    
    // 音声指導
    func adviceSensor(sucess: String, sensorJudge: Bool) {
        
        self.speakTimer?.invalidate()
        self.stopSpeacTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            
            switch(sensorJudge){
            case true:
                
                if self.speechSynthesizer.isSpeaking{
                    self.speechSynthesizer.pauseSpeaking(at: .word)
                }
                self.speeche(text: sucess)
                self.sensorjudge = false
                
                if !self.speechSynthesizer.isSpeaking{
                    self.trainingCount += 1
                    self.stopSpeacTimer?.invalidate()
                    self.speakTimes(SensorJudge: self.sensorjudge)
                }
                
            case false:
                
                if self.speechSynthesizer.isSpeaking{
                    self.speechSynthesizer.pauseSpeaking(at: .word)
                }
                self.speeche(text: sucess)
                self.sensorjudge = true
                
                if !self.speechSynthesizer.isSpeaking{
                    self.stopSpeacTimer?.invalidate()
                    self.speakTimes(SensorJudge: self.sensorjudge)
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
