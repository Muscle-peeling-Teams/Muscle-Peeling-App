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
    //staticでインスタンスを保持しておく
    // MotionManager.sharedでアクセスができる
    static let shared: SquatViewModel = .init()
    //privateのletでCMMotionManagerインスタンスを作成する
    private let queue = OperationQueue()
    private let motionManager = CMMotionManager()
    // 音声
    private var speechSynthesizer = AVSpeechSynthesizer()
    //カウントダウンの部分、初期値は5秒
    private var countDown = 5
    //設定セット数
    public var maxStage = 3
    //設定回数
    public var everyStageCount = 10
    //現在が何セット目かを示す部分
    @Published public  var currentStageIndex = 1
    //現在が何回目かを示す部分
    @Published public  var currentStageLeaveCount = 10
    //現在のステージ(直訳) 当前阶段 0,1,2
    private var stage: Int = 0
    //新たな下支えサイクルなのか(直訳) 是不是新的一个撑起周期
    private var newAction = true
    //？？？
    private var lastTime:Double = Date().timeIntervalSince1970
    //周期的閾値（調整可能）(直訳) 周期阀值 (可以调节)
    private let threshold_high = 1.5
    //サイクル閾値(直訳) 周期阀值
    private let threshold_low = 0.5
    //スクワットの間隔は0.3秒以上でなければならない(直訳) 两次下蹲时间间隔必须大于0.3s
    private let timeInterval:Double = 0.3
    //？？？
    private var lastList = [Double]()
    //時間測定関連
    private var prepareTimer: Timer?
    private var trainingTimer: Timer?
    //トレーニング準備の判定
    private var isPrepareIng = true
    //トレーニングの一時停止判定
    private var isPauseIng = false
    //トレーニングの終了判定
    public var isFinished = false
    
    // シングルトンにするためにinitを潰す
    private init() {}
    
    // カウントダウン
    //１：メニューからの遷移時に稼働、6秒前からスタートして5秒前からカウント
    func startPrepareTimer() {
        self.isPrepareIng = true
        self.countDown = 6
        prepareTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            
            if self.isFinished{
                self.prepareTimer?.invalidate()
                return
            }
            self.countDown -= 1
            print("\(self.countDown)")
            
            if self.countDown <= 0 {
                self.isPrepareIng = false
                self.prepareTimer?.invalidate()
                self.startSquat()
            }else{
                self.speeche(text: String(self.countDown))
            }
        }
    }
    
    //２：カウントダウンの0に合わせて稼働、
    func  startSquat() {
        self.speeche(text: "開始")
        self.currentStageIndex = 1
        self.currentStageLeaveCount = everyStageCount
        lastList.removeAll()
        newAction = true
        isFinished = false
        continueSquat()
    }
    
    func continueSquat() {
        if motionManager.isAccelerometerAvailable == false {
            speeche(text: "不支持陀螺仪")//ジャイロスコープ非対応(直訳)
            return
        }
        //使用代码块开始获取加速度数据
        //加速度データの取得を開始するためのコードブロックです。(直訳）
        self.motionManager.startAccelerometerUpdates(to: queue) { accelerometerData, error in
            // accelerometerDataはオプショナル型なので、安全に取り出す
            if error != nil{
                self.motionManager.stopAccelerometerUpdates()
                //エラーが発生しました(直訳)
                self.speeche(text: "发生错误")
                //加速度データの取得エラー(直訳)
                print("获取加速度数据出现错误：\(error.debugDescription)")
                return
            }
            
            if let accelerometerData = accelerometerData{
                let full = (accelerometerData.acceleration.x * accelerometerData.acceleration.x) + (accelerometerData.acceleration.y * accelerometerData.acceleration.y) + (accelerometerData.acceleration.z * accelerometerData.acceleration.z)
                // 取平方根计算综合加速度
                //平方根をとって合成加速度を計算する(直訳）
                let acceleration = sqrt(full)
                self.operationing(acceleration: acceleration)
            }else{
                //加速度データなし
                print("无加速度数据")
            }
        }
    }
    
    func operationing(acceleration:Double)   {
        //剔除异常数据(異常値データを除く)
        //前9个平均值(第1～9回平均)
        let average = lastList.reduce(0, {$0+$1})/Double((lastList.count))
        // comparison 剔除加速度明显过快或者过慢 (明らかに速すぎたり遅すぎたりする加速度は拒否されます)
        let comparison:Double = 5
        //平均值与当前值比较,不能相差太大(平均値が現在値と大きく異ならないこと)
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
                        
                        self.finishOneAction()
                    }
                    newAction = false
                }
                lastTime = Date().timeIntervalSince1970
            }
        }
        
        // 周期的开始(サイクルの始まり)
        if acceleration <= threshold_low && !newAction {
            newAction = true
        }
        if lastList.count >= 10 {
            lastList.remove(at: 0)
        }
    }
    
    func finishOneAction()  {
        speechSynthesizer.pauseSpeaking(at: .immediate)
        self.speeche(text: "上げてください")
        //アクションを完了させる(直訳)
        print("完成一个动作:\(self.currentStageLeaveCount)")
        self.currentStageLeaveCount -= 1
        if self.currentStageLeaveCount <= 0{
            // 完成一个阶段（フェーズを完了する）
            self.currentStageLeaveCount = self.everyStageCount
            if self.currentStageIndex >= self.maxStage {
                // 结束（終了）
                speechSynthesizer.pauseSpeaking(at: .immediate)
                self.overTraining()
                print("おわり")
            }else{
                // 下一个阶段（次のステージ）
                speechSynthesizer.pauseSpeaking(at: .immediate)
                self.speeche(text: "つぎのセットをはじめます")
                print("次の段階")
                self.currentStageIndex += 1
            }
        }
    }
    
    //暂停
    //サスペンション(直訳)、多分一時停止だと思うが、コードが。。。
    func pauseTraining() {
        if isPrepareIng {
            return
        }
        isPauseIng = !isPauseIng
        if isPauseIng {
            self.motionManager.stopAccelerometerUpdates()
            speechSynthesizer.pauseSpeaking(at: .immediate)
            speeche(text: "一時停止します")
            
        }else{
            self.continueSquat()
            speechSynthesizer.pauseSpeaking(at: .immediate)
            speeche(text: "再開します")
        }
    }
    
    // 停止
    func stopTraining() {
        if isPrepareIng {
            return
        }
        self.motionManager.stopAccelerometerUpdates()
        self.isFinished = true
        self.currentStageIndex = 1
        self.currentStageLeaveCount = everyStageCount
        lastList.removeAll()
        newAction = false
    }
    
    func overTraining() {
        isFinished = true
        self.motionManager.stopAccelerometerUpdates()
        self.currentStageIndex = 1
        self.currentStageLeaveCount = everyStageCount
        speechSynthesizer.pauseSpeaking(at: .immediate)
        self.speeche(text: "お疲れさまでした")
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
        print("说的是:\(text)")
    }
}


