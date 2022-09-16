//
//  ViewModel.swift
//  MyApp
//
//  Created by apple on 2022/9/16.
//

import CoreMotion
import SwiftUI
import AVFoundation
class SquatViewModel : ObservableObject {
    //次数
    
    
    // MotionManager.sharedでアクセスができる
   static let shared: SquatViewModel = .init()
    // privateのletでCMMotionManagerインスタンスを作成する
    private let motion = CMMotionManager()

    private let queue = OperationQueue()

    var backColor = Color.white

    // 音声
    private var speechSynthesizer : AVSpeechSynthesizer!


    // トレーニングを行えているか
    @Published var trainingSucess = 0

    @Published var plankTime = 5.0

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
        speakTimes()
        speeche(text: "スタート")
        startQueuedUpdates()
        
        trainingTime()
    }

    // トレーニング（制限時間式）
    func trainingTime() {
        trainingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            print("print\(self.setCount)")
            self.plankTime -= 0.1
            print("\(self.plankTime)")
            if self.plankTime <= 0.0 {
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
                plank()
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
                        self.plankTime = 5.0
                        self.plank()
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
        plankTime = 60.0
        setCount = 1
        speechSynthesizer.pauseSpeaking(at: .word)
        speeche(text: "お疲れさまでした")
        buttonOpacity.toggle()
        print("終了")
    }

    // 音声作動範囲
    func speakTimes() {
        speakTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if self.x >= -0.08 {
                // TODO: 複数対応できるようにadviceとsucessの部分を配列で読ませる
                self.adviceSensor(advice: "もう少し腰を下げましょう", sucess: "その位置です")
            } else if self.x <= -0.12 {
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
            if self.x <= -0.08 && self.x >= -0.12 {
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


    @Published var num = 0
    var newAction = true //是不是新的一个撑起周期
    var lastTime:Double = Date().timeIntervalSince1970
    let threshold_high = 1.5 //周期阀值 (可以调节)
    let threshold_low = 0.5 //周期阀值
    let timeInterval:Double = 0.3 //两次下蹲时间间隔必须大于0.3s
    var lastList = [Double]()
    let motionManager = CMMotionManager()
    var maxCount = 10
    
    func  start() {
        self.num = 0
        lastList.removeAll()
        newAction = true
        if motionManager.isAccelerometerAvailable == false {
            print("不支持加速计")
            return
        }
        let queue = OperationQueue()
        //使用代码块开始获取加速度数据
        self.motionManager.startAccelerometerUpdates(to: queue) { accelerometerData, error in
            if error != nil{
                self.stop()
                print("获取加速度数据出现错误：\(error.debugDescription)")
                
                return
            }
            if let accelerometerData = accelerometerData{
                // print("加速度为\n------\nX轴：\(accelerometerData.acceleration.x) \nY轴：\(accelerometerData.acceleration.y) \nZ 轴：\(accelerometerData.acceleration.z)")
                let full = (accelerometerData.acceleration.x * accelerometerData.acceleration.x) + (accelerometerData.acceleration.y * accelerometerData.acceleration.y) + (accelerometerData.acceleration.z * accelerometerData.acceleration.z)
                // 取平方根计算综合加速度
                let acceleration = sqrt(full)
                self.operationing(acceleration: acceleration)
                
            }else{
                print("无加速度数据")
            }
            
            
        }
    }
    
    func stop()  {
        self.motionManager.stopAccelerometerUpdates()
    }
    
    func operationing(acceleration:Double)   {
        // print(acceleration)
        //剔除异常数据
        //前9个平均值
        let average = lastList.reduce(0, {$0+$1})/Double((lastList.count))
        // comparison 剔除加速度明显过快或者过慢 (正常0,)
        let comparison:Double = 5
        //平均值与当前值比较,不能相差太大
        if lastList.count >= 9 && abs(average - acceleration) > comparison{
            print("异常数据")
            return
        }
        
        lastList.append(acceleration)
        //周期的结束
        if acceleration >= threshold_high && newAction {
            
            //求和取平均值
            let average = lastList.reduce(0, {$0+$1})/Double((lastList.count))
            if lastList.count >= 10 && average < threshold_high {
                //两次间隔必须大于0.3s
                let currentTime = Date().timeIntervalSince1970
                if  currentTime - lastTime > timeInterval{
                    DispatchQueue.main.async {
                        self.num += 1
                    }
                    
                    print("完成一个动作:\(self.num)")
                    newAction = false
                }
                lastTime = Date().timeIntervalSince1970
            }
        }
        
        // 周期的开始
        if acceleration <= threshold_low && !newAction {
            newAction = true
        }
        
        if lastList.count >= maxCount {
            lastList.remove(at: 0)
        }
    }
}


