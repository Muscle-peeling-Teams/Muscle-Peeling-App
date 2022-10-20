////
////  ViewModel.swift
////  MyApp
////
////  Created by apple on 2022/9/16.
////
//
//import CoreMotion
//import SwiftUI
//import AVFoundation
//class SquatViewModel : ObservableObject {
//    //staticでインスタンスを保持しておく
//    // MotionManager.sharedでアクセスができる
//    static let shared: SquatViewModel = .init()
//    //privateのletでCMMotionManagerインスタンスを作成する
//    private let queue = OperationQueue()
//    private let motionManager = CMMotionManager()
//    // 音声
//    private var speechSynthesizer = AVSpeechSynthesizer()
//    //カウントダウンの部分、初期値は5秒
//    private var countDown = 5
//    //設定セット数
//    public var maxStage = 3
//    //設定回数
//    public var everyStageCount = 10
//    //現在が何セット目かを示す部分
//    @Published public  var currentStageIndex = 1
//    //現在が何回目かを示す部分
//    @Published public  var currentStageLeaveCount = 10
//    //現在のステージ(直訳) 当前阶段 0,1,2
//    private var stage: Int = 0
//    //新たな下支えサイクルなのか(直訳) 是不是新的一个撑起周期
//    private var newAction = true
//    //？？？
//    private var lastTime:Double = Date().timeIntervalSince1970
//    //周期的閾値（調整可能）(直訳) 周期阀值 (可以调节)
//    private let threshold_high = 1.5
//    //サイクル閾値(直訳) 周期阀值
//    private let threshold_low = 0.5
//    //スクワットの間隔は0.3秒以上でなければならない(直訳) 两次下蹲时间间隔必须大于0.3s
//    private let timeInterval:Double = 0.3
//    //？？？
//    private var lastList = [Double]()
//    //時間測定関連
//    private var prepareTimer: Timer?
//    private var trainingTimer: Timer?
//    //トレーニング準備の判定
//    private var isPrepareIng = true
//    //トレーニングの一時停止判定
//    private var isPauseIng = false
//    //トレーニングの終了判定
//    public var isFinished = false
//
//    // シングルトンにするためにinitを潰す
//    private init() {}
//
//    // カウントダウン
//    //１：メニューからの遷移時に稼働、6秒前からスタートして5秒前からカウント
//    func startPrepareTimer() {
//        self.isPrepareIng = true
//        self.countDown = 6
//        prepareTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//
//            if self.isFinished{
//                self.prepareTimer?.invalidate()
//                return
//            }
//            self.countDown -= 1
//            print("\(self.countDown)")
//
//            if self.countDown <= 0 {
//                self.isPrepareIng = false
//                self.prepareTimer?.invalidate()
//                self.startSquat()
//            }else{
//                self.speeche(text: String(self.countDown))
//            }
//        }
//    }
//
//    //２：カウントダウンの0に合わせて稼働、
//    func  startSquat() {
//        self.speeche(text: "開始")
//        self.currentStageIndex = 1
//        self.currentStageLeaveCount = everyStageCount
//        lastList.removeAll()
//        newAction = true
//        isFinished = false
//        continueSquat()
//    }
//
//    func continueSquat() {
//        if motionManager.isAccelerometerAvailable == false {
//            speeche(text: "不支持陀螺仪")//ジャイロスコープ非対応(直訳)
//            return
//        }
//        //使用代码块开始获取加速度数据
//        //加速度データの取得を開始するためのコードブロックです。(直訳）
//        self.motionManager.startAccelerometerUpdates(to: queue) { accelerometerData, error in
//            // accelerometerDataはオプショナル型なので、安全に取り出す
//            if error != nil{
//                self.motionManager.stopAccelerometerUpdates()
//                //エラーが発生しました(直訳)
//                self.speeche(text: "发生错误")
//                //加速度データの取得エラー(直訳)
//                print("获取加速度数据出现错误：\(error.debugDescription)")
//                return
//            }
//
//            if let accelerometerData = accelerometerData{
//                let full = (accelerometerData.acceleration.x * accelerometerData.acceleration.x) + (accelerometerData.acceleration.y * accelerometerData.acceleration.y) + (accelerometerData.acceleration.z * accelerometerData.acceleration.z)
//                // 取平方根计算综合加速度
//                //平方根をとって合成加速度を計算する(直訳）
//                let acceleration = sqrt(full)
//                self.operationing(acceleration: acceleration)
//            }else{
//                //加速度データなし
//                print("无加速度数据")
//            }
//        }
//    }
//
//    func operationing(acceleration:Double)   {
//        //剔除异常数据(異常値データを除く)
//        //前9个平均值(第1～9回平均)
//        let average = lastList.reduce(0, {$0+$1})/Double((lastList.count))
//        // comparison 剔除加速度明显过快或者过慢 (明らかに速すぎたり遅すぎたりする加速度は拒否されます)
//        let comparison:Double = 5
//        //平均值与当前值比较,不能相差太大(平均値が現在値と大きく異ならないこと)
//        if lastList.count >= 9 && abs(average - acceleration) > comparison{
//            print("异常数据")
//            return
//        }
//
//        lastList.append(acceleration)
//        //周期的结束
//        if acceleration >= threshold_high && newAction {
//
//            //求和取平均值
//            let average = lastList.reduce(0, {$0+$1})/Double((lastList.count))
//            if lastList.count >= 10 && average < threshold_high {
//                //两次间隔必须大于0.3s
//                let currentTime = Date().timeIntervalSince1970
//                if  currentTime - lastTime > timeInterval{
//                    DispatchQueue.main.async {
//
//                        self.finishOneAction()
//                    }
//                    newAction = false
//                }
//                lastTime = Date().timeIntervalSince1970
//            }
//        }
//
//        // 周期的开始(サイクルの始まり)
//        if acceleration <= threshold_low && !newAction {
//            newAction = true
//        }
//        if lastList.count >= 10 {
//            lastList.remove(at: 0)
//        }
//    }
//
//    func finishOneAction()  {
//        speechSynthesizer.pauseSpeaking(at: .immediate)
//        self.speeche(text: "上げてください")
//        //アクションを完了させる(直訳)
//        print("完成一个动作:\(self.currentStageLeaveCount)")
//        self.currentStageLeaveCount -= 1
//        if self.currentStageLeaveCount <= 0{
//            // 完成一个阶段（フェーズを完了する）
//            self.currentStageLeaveCount = self.everyStageCount
//            if self.currentStageIndex >= self.maxStage {
//                // 结束（終了）
//                speechSynthesizer.pauseSpeaking(at: .immediate)
//                self.overTraining()
//                print("おわり")
//            }else{
//                // 下一个阶段（次のステージ）
//                speechSynthesizer.pauseSpeaking(at: .immediate)
//                self.speeche(text: "つぎのセットをはじめます")
//                print("次の段階")
//                self.currentStageIndex += 1
//            }
//        }
//    }
//
//    //暂停
//    //サスペンション(直訳)、多分一時停止だと思うが、コードが。。。
//    func pauseTraining() {
//        if isPrepareIng {
//            return
//        }
//        isPauseIng = !isPauseIng
//        if isPauseIng {
//            self.motionManager.stopAccelerometerUpdates()
//            speechSynthesizer.pauseSpeaking(at: .immediate)
//            speeche(text: "一時停止します")
//
//        }else{
//            self.continueSquat()
//            speechSynthesizer.pauseSpeaking(at: .immediate)
//            speeche(text: "再開します")
//        }
//    }
//
//    // 停止
//    func stopTraining() {
//        if isPrepareIng {
//            return
//        }
//        self.motionManager.stopAccelerometerUpdates()
//        self.isFinished = true
//        self.currentStageIndex = 1
//        self.currentStageLeaveCount = everyStageCount
//        lastList.removeAll()
//        newAction = false
//    }
//
//    func overTraining() {
//        isFinished = true
//        self.motionManager.stopAccelerometerUpdates()
//        self.currentStageIndex = 1
//        self.currentStageLeaveCount = everyStageCount
//        speechSynthesizer.pauseSpeaking(at: .immediate)
//        self.speeche(text: "お疲れさまでした")
//    }
//
//    // 自動音声機能
//    func speeche(text: String) {
//        // AVSpeechSynthesizerのインスタンス作成
//        speechSynthesizer = AVSpeechSynthesizer()
//        // 読み上げる、文字、言語などの設定
//        let utterance = AVSpeechUtterance(string: text) // 読み上げる文字
//        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP") // 言語
//        utterance.rate = 0.5 // 読み上げ速度
//        utterance.pitchMultiplier = 1.0 // 読み上げる声のピッチ
//        utterance.preUtteranceDelay = 0.0
//        speechSynthesizer.speak(utterance)
//        print("说的是:\(text)")
//    }
//}
//
//

import CoreMotion
import SwiftUI
import AVFoundation

final class SquatViewModel: ObservableObject{
    //staticでインスタンスを保持しておく
    //MotionManager.sharedでアクセスができる
    static let shared: SquatViewModel = .init()
    //privateのletでCMMotionManagerインスタンスを作成する
    private let motion = CMMotionManager()
    private let queue = OperationQueue()
    var backColor = Color.white
    //音声
    private var speechSynthesizer: AVSpeechSynthesizer!
    //トレーニングの上下判定
    @Published var sqsensorjudge = true
    //トレーニングの成功、一回の成功
    @Published var sqtrainingSucess = false
    //トレーニングの現在の回数
    @Published var sqtrainingCount = 1
    //トレーニングの現在のセット数
    @Published var sqtrainingSetCount = 1
    //トレーニングの回数設定(テストでは3)
    @Published var sqsettingCount = 10
    //トレーニングの設定セット数
    @Published var sqsettingSetCount = 3
    //スタートまでのカウントダウン
    @Published var sqcountDown = 5
    // トレーニング時のボタンを透明にする
    @Published var sqbuttonOpacity = true
    //トレーニング終了判定
    @Published var sqtrainingFinished = false
    //メニューへ戻るボタンの表示判定
    @Published var sqfinishActionButton = false
    //一時停止用の判定変数
    @Published var sqpauseNum = 3
    //右左の足の入れ替え
    @Published var legChangeCount = 0
    
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
    
    func sqStartQueuedUpdates() {
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
    
    func squatReady(){
        self.sqcountDown = 5
        self.speeche(text: String(self.sqcountDown))
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] _ in
            
            self.sqcountDown -= 1
            if self.sqcountDown > 0 {
                self.speeche(text: String(self.sqcountDown))
            }
            print("\(self.sqcountDown)")
            
            if self.sqcountDown <= 0 {
                self.timer?.invalidate()
                self.sqbuttonOpacity.toggle()
                self.squatStart()
            }
        }
    }
    
    // 腕立て
    func squatStart() {
        sqtrainingCount = 1
        sqpauseNum = 0
        speakTimes(SensorJudge:sqsensorjudge)
        speeche(text: "はじめてください")
        sqStartQueuedUpdates()
        squatCount()
    }
    
    //一時停止からの再開処理
    func pauseRestart(){
        speechSynthesizer.pauseSpeaking(at: .word)
        self.speechSynthesizer.pauseSpeaking(at: .word)
        self.speakTimes(SensorJudge:self.sqsensorjudge)
        self.speeche(text: "再開してください")
        self.pauseTimer?.invalidate()
        self.sqsensorjudge = true
        self.sqStartQueuedUpdates()
        self.squatStart()
    }
    
    // トレーニング（回数式）
    func squatCount() {
        trainingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){_ in
            switch(self.sqsensorjudge){
                
            case true:
                if self.x >= 0.95{
                    self.sqtrainingSucess = true
                }else{
                    self.sqtrainingSucess = false
                }

            case false:
                if self.x <= 0.3{
                    self.sqtrainingSucess = true

                }else{
                    self.sqtrainingSucess = false
                }
            }
        }
    }
    
    //こっちは足を入れ替える方の小休憩
    func pauseActionChangeLeg(){
        sqpauseNum = 3
        self.motion.stopDeviceMotionUpdates()
        self.trainingTimer?.invalidate()
        self.speakTimer?.invalidate()
        self.stopSpeacTimer?.invalidate()
        self.speeche(text: "休憩です。足を入れ替えて準備をしましょう。休憩時間は30秒です")
        var pauseTime = 30
        
        pauseTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){_ in
            pauseTime -= 1
            
            if pauseTime <= 5 {
                if pauseTime > 0 {
                    self.speeche(text: String(pauseTime))
                }
                
                if pauseTime <= 0{
                    self.pauseTimer?.invalidate()
                    self.sqsensorjudge = true
                    pauseTime = 0
                    self.squatStart()
                }
            }
        }
    }
    
    //1セット(右と左)終了時のアクション
    //キツめのメニューであるため、長めの休憩。1分で設定の上でカウント10から音声案内。
    func pauseAction(){
        sqpauseNum = 3
        self.motion.stopDeviceMotionUpdates()
        self.trainingTimer?.invalidate()
        self.speakTimer?.invalidate()
        self.stopSpeacTimer?.invalidate()
        self.speeche(text: "セット休憩です。休憩時間は60秒です")
        var pauseTime = 60
        
        pauseTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){_ in
            pauseTime -= 1
            
            if pauseTime <= 10 {
                if pauseTime > 0 {
                    self.speeche(text: String(pauseTime))
                }
                
                if pauseTime <= 0{
                    self.pauseTimer?.invalidate()
                    self.sqsensorjudge = true
                    pauseTime = 0
                    self.squatStart()
                }
            }
        }
    }
    
    //一時停止時のアクション
    func pauseTraining(){
        speechSynthesizer.pauseSpeaking(at: .word)
        if sqpauseNum == 0 {
            sqpauseNum = 1
            speechSynthesizer.pauseSpeaking(at: .word)
            print("一時停止")
            self.trainingTimer?.invalidate()
            self.speakTimer?.invalidate()
            self.stopSpeacTimer?.invalidate()
            speeche(text: "一時停止します、再開する場合は再度このボタンを押してください")
            print(sqpauseNum)
            
        } else if sqpauseNum == 1 {
            sqpauseNum = 0
            speechSynthesizer.pauseSpeaking(at: .word)
            print("再開")
            if !speechSynthesizer.isSpeaking {
                speechSynthesizer.pauseSpeaking(at: .word)
            }
            pauseRestart()
            print(sqpauseNum)
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
        self.sqbuttonOpacity.toggle()
        print("中止")
        sqtrainingFinished = true
    }
    
    func finishTraining(){
        // 終了
        speechSynthesizer.pauseSpeaking(at: .word)
        self.motion.stopDeviceMotionUpdates()
        self.trainingTimer?.invalidate()
        self.speakTimer?.invalidate()
        self.stopSpeacTimer?.invalidate()
        self.speeche(text: "終了です、お疲れ様でした")
        self.sqbuttonOpacity.toggle()
        print("終了")
        sqtrainingFinished = true
    }
    
    // 音声作動範囲
    //sucess判定は腕立てでいる？腰が浮いてるとかの判定？
    func speakTimes(SensorJudge: Bool) {
        
        speakTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            
            switch(self.sqsensorjudge){
                
            case true:
                
                if self.x >= 0.95{
                    //現在の回数(init:0) > 設定回数(test:3)
                    if self.sqtrainingCount >= self.sqsettingCount{
                        //現在のセット数と設定セット数の比較
                        if self.sqtrainingSetCount >= self.sqsettingSetCount{
                            //終了のアクション
                            self.finishTraining()
                            
                            //片足のみ終わった場合の判定、次に両足分終わったことを判定するための変数の値変更と
                        }else if self.legChangeCount == 0{
                            //セット数を加算、センサーを停止、足を変える小休憩
                            self.legChangeCount = 1
                            self.motion.stopDeviceMotionUpdates()
                            self.pauseActionChangeLeg()

                            //両足分終わった場合の判定
                            //次また片足分の判定する変数の値変更
                        }else if self.legChangeCount == 1{
                            self.legChangeCount = 0
                            self.sqtrainingSetCount += 1
                            self.motion.stopDeviceMotionUpdates()
                            self.pauseAction()
                        }
                        
                    } else {
                        self.adviceSensor(sucess: "上げてください", sensorJudge: self.sqsensorjudge)
                        self.sqsensorjudge = false
                    }
                }
                
            case false:
                if self.x <= 0.3{
                    self.adviceSensor(sucess: "\(self.sqtrainingCount)回、下げてください", sensorJudge: self.sqsensorjudge)
                    self.sqsensorjudge = true
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
                self.sqsensorjudge = false
                
                if !self.speechSynthesizer.isSpeaking{
                    self.stopSpeacTimer?.invalidate()
                    self.speakTimes(SensorJudge: self.sqsensorjudge)
                }
                
            case false:
                
                if self.speechSynthesizer.isSpeaking{
                    self.speechSynthesizer.pauseSpeaking(at: .word)
                }
                self.speeche(text: sucess)
                self.sqsensorjudge = true
                
                if !self.speechSynthesizer.isSpeaking{
                    self.sqtrainingCount += 1
                    self.stopSpeacTimer?.invalidate()
                    self.speakTimes(SensorJudge: self.sqsensorjudge)
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
