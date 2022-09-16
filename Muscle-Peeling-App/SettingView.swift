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
    var fruits = ["1", "2", "3", "4" ]
    @State private var selectedFruit = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            ScrollView{
                ForEach(Menu, id: \.self){ name in
                    VStack(spacing: 0){
                        
                        
                        
                        Text("\(name)")
                            .frame(width: 300, height: 30, alignment: .leading)
                        
                        aaa()
                        
                        
                        
                        
                    }.frame(width: UIScreen.main.bounds.width*1.1)
                    
                }
                ForEach(menyu, id: \.self){ name in
                    VStack(spacing: 0){
                        
                        
                        
                        Text("\(name)")
                            .frame(width: 300, height: 30, alignment: .leading)
                        
                        bb()
                        
                        
                        
                        
                    }.frame(width: UIScreen.main.bounds.width*1.1)
                    
                }
            }
            ZStack{
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width*1.1,
                           height: 100)
                    .edgesIgnoringSafeArea(.all)
                Button(action: {
                    dismiss()
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

struct settei_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

struct bb: View {
    
    let w = UIScreen.main.bounds.width
    var fruits = ["1","2","3","4","5"]
    @State private var selectedFruit = 0
    @State var abc: [String] = ["1","2","3","4","5","6","7","8","9","10",
                                "11","12","13","14","15","16","17","18","19","20",
                                "21","22","23","24","25","26","27","28","29","30",
                                "31","32","33","34","35","36","37","38","39","40",
                                "41","42","43","44","45","46","47","48","49","50"]
    @State private var bbb = 0
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color.white)
                .shadow(radius: 10)
            HStack {
                Picker(selection: $selectedFruit,
                       label: Text("")) {
                    ForEach(0..<5) {
                        Text(self.fruits[$0])
                            .font(.largeTitle)
                        
                    }
                }
                Text("セット")
                    .font(.largeTitle)
                
                Picker(selection: $bbb,
                       label: Text("")) {
                    
                    ForEach(0..<50) {
                        Text(self.abc[$0])
                            .font(.largeTitle)
                        
                    }
                }
                Text("回")
                    .font(.largeTitle)
                
                
                
            }
        }.frame(width: w*0.8, height: w*0.3)
            .onAppear{
                for i in 1...180{
                    self.abc.append("\(i)")
                }
            }
    }
}

struct aaa: View {
    
    let w = UIScreen.main.bounds.width
    var fruits = ["1","2","3","4","5"]
    @State private var selectedFruit = 0
    @State var abc = ["1","2","3","4","5","6","7","8","9","10",
                      "11","12","13","14","15","16","17","18","19","20",
                      "21","22","23","24","25","26","27","28","29","30",
                      "31","32","33","34","35","36","37","38","39","40",
                      "41","42","43","44","45","46","47","48","49","50",
                      "51","52","53","54","55","56","57","58","59","60",
                      "61","62","63","64","65","66","67","48","49","50",
                      "71","72","73","44","45","46","47","48","49","50",
                      "81","82","43","44","45","46","47","48","49","50",
                      "91","92","93","94","95","96","97","98","99","100",
                      "101","102","103","104","105","106","107","108","109","110",
                      "111","112","113","114","115","116","117","118","119","120",
                      "121","122","123","124","125","126","127","128","129","130",
                      "131","132","133","134","135","136","137","138","139","140",
                      "141","142","143","144","145","146","147","148","149","150",
                      "151","152","153","154","155","156","157","158","159","160",
                      "161","162","163","164","165","166","167","168","169","170",
                      "171","172","173","174","175","176","177","178","179","180"]
    @State private var bbb = 0
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color.white)
                .shadow(radius: 10)
            HStack {
                Picker(selection: $selectedFruit,
                       label: Text("")) {
                    ForEach(0..<5) {
                        Text(self.fruits[$0])
                            .font(.largeTitle)
                        
                    }
                }
                Text("セット")
                    .font(.largeTitle)
                
                Picker(selection: $bbb,
                       label: Text("")) {
                    ForEach(0..<180) {
                        Text(self.abc[$0])
                            .font(.largeTitle)
                        
                    }
                }
                Text("秒")
                    .font(.largeTitle)
                
                
                
            }
        }.frame(width: w*0.8, height: w*0.3)
        
    }
}


