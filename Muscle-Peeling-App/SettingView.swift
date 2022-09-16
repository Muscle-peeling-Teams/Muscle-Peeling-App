//
//  settei.swift
//  MotionManager
//
//  Created by cmStudent on 2022/09/06.
//

import SwiftUI

struct SettingView: View {
    let Menu = ["筋肉","筋肉位置","永井","おいしい","やみー","感謝感謝"]
    var fruits = ["1", "2", "3", "4" ]
    @State private var selectedFruit = 0

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
            }
            ZStack{
                Rectangle()
                    .frame(width: .infinity,
                    height: 100)
                    .edgesIgnoringSafeArea(.all)
                    Spacer()
                    Button(action: {
                        print("おまえくさい")
                    }){
                        Text("   選択")
                            .foregroundColor(Color.white)
                            
                            .font(.custom("HiraginoSans-W3", size: 30))
                    }
            }.position(x: UIScreen.main.bounds.width/2,
                       y: UIScreen.main.bounds.height/2)
            
        }
    }
}

struct settei_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

struct aaa: View {
    
    let w = UIScreen.main.bounds.width
    var fruits = ["1","2", "3", "4", "5" ]
       @State private var selectedFruit = 0
    var abc = ["1","2", "3", "4", "5" ]
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
                    ForEach(0..<5) {
                        Text(self.abc[$0])
                            .font(.largeTitle)
                          
                    }
                }
                Text("回")
                    .font(.largeTitle)
                
                
                
            }
        }.frame(width: w*0.8, height: w*0.3)
    }
}


