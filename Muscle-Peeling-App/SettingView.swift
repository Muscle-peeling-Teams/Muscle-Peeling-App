//
//  settei.swift
//  MotionManager
//
//  Created by cmStudent on 2022/09/06.
//

import SwiftUI

struct SettingView: View {
    let Menu = ["クランク","バッククランク"]
    let menyu = ["ブルガリアンスクワット","スクワット","腹筋","腕立て"]
    var fruits = ["1","2","3","4","5"]
    let w = UIScreen.main.bounds.width
    
    
    @ObservedObject var viewModel: SettingViewModel
    @ObservedObject var plankViewModel: PlankViewModel = .shared
    @ObservedObject var backPlankViewModel: BackPlankViewModel = .shared
    @ObservedObject var pushUpViewModel: PushUpMotionManager = .shared
    @ObservedObject var bulgarianSquatViewModel: SquatViewModel = .shared
    @ObservedObject var absViewModel: MotionManager = .shared
    
    @Environment(\.dismiss) var dismiss
    @State var plays: [String] = ["1","2","3","4","5","6","7","8","9","10",
                                  "11","12","13","14","15","16","17","18","19","20",
                                  "21","22","23","24","25","26","27","28","29","30",
                                  "31","32","33","34","35","36","37","38","39","40",
                                  "41","42","43","44","45","46","47","48","49","50"]
    @State var times = ["1","2","3","4","5","6","7","8","9","10",
                      "11","12","13","14","15","16","17","18","19","20",
                      "21","22","23","24","25","26","27","28","29","30",
                      "31","32","33","34","35","36","37","38","39","40",
                      "41","42","43","44","45","46","47","48","49","50",
                      "51","52","53","54","55","56","57","58","59","60",
                      "61","62","63","64","65","66","67","48","49","50",
                      "71","72","73","74","75","76","77","78","79","80",
                      "81","82","83","84","85","86","87","88","89","90",
                      "91","92","93","94","95","96","97","98","99","100",
                      "101","102","103","104","105","106","107","108","109","110",
                      "111","112","113","114","115","116","117","118","119","120",
                      "121","122","123","124","125","126","127","128","129","130",
                      "131","132","133","134","135","136","137","138","139","140",
                      "141","142","143","144","145","146","147","148","149","150",
                      "151","152","153","154","155","156","157","158","159","160",
                      "161","162","163","164","165","166","167","168","169","170",
                      "171","172","173","174","175","176","177","178","179","180"]
    
    var body: some View {
        ZStack{
            ScrollView{
                VStack(spacing: 0){
                    
                    
                    
                    Text("プランク")
                        .frame(width: 300, height: 30, alignment: .leading)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.white)
                            .shadow(radius: 10)
                        HStack {
                            Picker(selection: $viewModel.selectedSet[0],
                                   label: Text("")) {
                                ForEach(0..<5) {
                                    Text(self.fruits[$0])
                                        .font(.largeTitle)
                                    
                                }
                            }
                                
                            Text("セット")
                                .font(.largeTitle)
                            
                            Picker(selection: $viewModel.selectedPlay[0],
                                   label: Text("")) {
                                ForEach(0..<180) {
                                    Text(self.times[$0])
                                        .font(.largeTitle)
                                    
                                }
                            }
                            Text("秒")
                                .font(.largeTitle)
                            
                            
                            
                        }
                    }.frame(width: w*0.8, height: w*0.3)
                        .onChange(of: viewModel.selectedSet[0]) { newValue in
                            viewModel.selectedSet[0] = newValue
                        }
                        .onChange(of: viewModel.selectedPlay[0]) {
                            newValue in
                            viewModel.selectedPlay[0] = newValue
                        }
                    
                    
                    
                    
                }.frame(width: UIScreen.main.bounds.width*1.1)
                
                VStack(spacing: 0){
                    
                    
                    
                    Text("バックプランク")
                        .frame(width: 300, height: 30, alignment: .leading)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.white)
                            .shadow(radius: 10)
                        HStack {
                            Picker(selection: $viewModel.selectedSet[1],
                                   label: Text("")) {
                                ForEach(0..<5) {
                                    Text(self.fruits[$0])
                                        .font(.largeTitle)
                                    
                                }
                            }
                                
                            Text("セット")
                                .font(.largeTitle)
                            
                            Picker(selection: $viewModel.selectedPlay[1],
                                   label: Text("")) {
                                ForEach(0..<180) {
                                    Text(self.times[$0])
                                        .font(.largeTitle)
                                    
                                }
                            }
                            Text("秒")
                                .font(.largeTitle)
                            
                            
                            
                        }
                    }.frame(width: w*0.8, height: w*0.3)
                        .onChange(of: viewModel.selectedSet[1]) { newValue in
                            viewModel.selectedSet[1] = newValue
                        }
                        .onChange(of: viewModel.selectedPlay[1]) {
                            newValue in
                            viewModel.selectedPlay[1] = newValue
                        }
                    
                    
                }.frame(width: UIScreen.main.bounds.width*1.1)
                
                VStack(spacing: 0){
                    
                    
                    
                    Text("ブルガリアンスクワット")
                        .frame(width: 300, height: 30, alignment: .leading)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.white)
                            .shadow(radius: 10)
                        HStack {
                            Picker(selection: $viewModel.selectedSet[2],
                                   label: Text("")) {
                                ForEach(0..<5) {
                                    Text(self.fruits[$0])
                                        .font(.largeTitle)
                                    
                                }
                            }
                            Text("セット")
                                .font(.largeTitle)
                            
                            Picker(selection: $viewModel.selectedPlay[2],
                                   label: Text("")) {
                                
                                ForEach(0..<50) {
                                    Text(self.plays[$0])
                                        .font(.largeTitle)
                                    
                                }
                            }
                            Text("回")
                                .font(.largeTitle)
                            
                            
                            
                        }
                    }.frame(width: w*0.8, height: w*0.3)
                        .onChange(of: viewModel.selectedSet[2]) { newValue in
                            viewModel.selectedSet[2] = newValue
                        }
                        .onChange(of: viewModel.selectedPlay[2]) {
                            newValue in
                            viewModel.selectedPlay[2] = newValue
                        }
                    
                    
                    
                    
                }.frame(width: UIScreen.main.bounds.width*1.1)
                
                
                
                VStack(spacing: 0){
                    
                    
                    
                    Text("腹筋")
                        .frame(width: 300, height: 30, alignment: .leading)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.white)
                            .shadow(radius: 10)
                        HStack {
                            Picker(selection: $viewModel.selectedSet[4],
                                   label: Text("")) {
                                ForEach(0..<5) {
                                    Text(self.fruits[$0])
                                        .font(.largeTitle)
                                    
                                }
                            }
                            Text("セット")
                                .font(.largeTitle)
                            
                            Picker(selection: $viewModel.selectedPlay[4],
                                   label: Text("")) {
                                
                                ForEach(0..<50) {
                                    Text(self.plays[$0])
                                        .font(.largeTitle)
                                    
                                }
                            }
                            Text("回")
                                .font(.largeTitle)
                            
                            
                            
                        }
                    }.frame(width: w*0.8, height: w*0.3)
                        .onChange(of: viewModel.selectedSet[4]) { newValue in
                            viewModel.selectedSet[4] = newValue
                        }
                        .onChange(of: viewModel.selectedPlay[4]) {
                            newValue in
                            viewModel.selectedPlay[4] = newValue
                        }
                    
                    
                    
                    
                }.frame(width: UIScreen.main.bounds.width*1.1)
                
                VStack(spacing: 0){
                    
                    
                    
                    Text("腕立て")
                        .frame(width: 300, height: 30, alignment: .leading)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.white)
                            .shadow(radius: 10)
                        HStack {
                            Picker(selection: $viewModel.selectedSet[5],
                                   label: Text("")) {
                                ForEach(0..<5) {
                                    Text(self.fruits[$0])
                                        .font(.largeTitle)
                                    
                                }
                            }
                            Text("セット")
                                .font(.largeTitle)
                            
                            Picker(selection: $viewModel.selectedPlay[5],
                                   label: Text("")) {
                                
                                ForEach(0..<50) {
                                    Text(self.plays[$0])
                                        .font(.largeTitle)
                                    
                                }
                            }
                            Text("回")
                                .font(.largeTitle)
                            
                            
                            
                        }
                    }.frame(width: w*0.8, height: w*0.3)
                        .onChange(of: viewModel.selectedSet[5]) { newValue in
                            viewModel.selectedSet[5] = newValue
                        }
                        .onChange(of: viewModel.selectedPlay[5]) {
                            newValue in
                            viewModel.selectedPlay[5] = newValue
                        }
                    
                    
                    
                    
                }.frame(width: UIScreen.main.bounds.width*1.1)
                
                VStack {
                    // 下の選択と重ならないために
                }
                .frame(width: w*0.8, height: w*0.3)
                
            }
            
            ZStack{
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width*1.1,
                           height: 100)
                    .edgesIgnoringSafeArea(.all)
                Button(action: {
                    dismiss()
                    for i in 0..<6 {
                        viewModel.set[i] = viewModel.selectedSet[i] + 1
                        viewModel.play[i] = viewModel.selectedPlay[i] + 1
                    }
                    plankViewModel.setMaxCount = viewModel.SetTraining(num: 0)
                    plankViewModel.maxPlankTime = Double(viewModel.CountTraining(num: 0))
                    
<<<<<<< HEAD
                    backPlankViewModel.setCount = viewModel.SetTraining(num: 1)
                    backPlankViewModel.backplankTime = Double(viewModel.CountTraining(num: 1))
=======
                    backPlankViewModel.setMaxCount = viewModel.SetTraining(num: 1)
                    backPlankViewModel.setCount = viewModel.CountTraining(num: 1)
>>>>>>> origin/main
                    bulgarianSquatViewModel.setMaxCount = viewModel.SetTraining(num: 2)
                    bulgarianSquatViewModel.maxCount = viewModel.SetTraining(num: 2)
                    absViewModel.setMaxCount = viewModel.SetTraining(num: 4)
                    absViewModel.setCount = viewModel.CountTraining(num: 4)
                    pushUpViewModel.settingCount = viewModel.CountTraining(num: 5)
                    pushUpViewModel.settingSetCount = viewModel.SetTraining(num: 5)
                }){
                    Text("    選択")
                        .foregroundColor(Color.white)
                        .font(.custom("HiraginoSans-W3", size: 30))
                }
            }.position(x: UIScreen.main.bounds.width * 0.5,
                       y: UIScreen.main.bounds.height * 0.9)
            
            
        }
    }
}




