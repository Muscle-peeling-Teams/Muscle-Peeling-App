import SwiftUI

struct ReadyView: View {
    //設定時の回数
    @State var count = 10
    //設定時のセット数
    @State var setNum = 3
    @State var navigated = false
    @Binding var image : String
    var example = ["腹筋：\n１.仰向けになり、交差状態からスタート\n2. おへそをのぞき込むようなイメージでゆっくりと息を吐きながら上半身を持ち上げる。  \nこの時に、腹筋を縦に縮ませるようにして力を込めるのがポイント。",
                   "プランク：\n1.頭からかかとまでが一直線になるように意識する\n2.その姿勢のままキープ",
                   "バックプランク：\n1.マットなどを敷いた上に仰向けで寝っ転がる\n2.マットなどを敷いた上に仰向けで寝っ転がる",
                   "スクワット：\n1.足を肩幅より少し広めに開きます。\n2.股関節を曲げ、お尻を真下に落とすイメージで膝を曲げます。\n3 お尻を後ろに突き出し、膝が爪先より前に出ないようにしましょう",
                   "ブルガリアンスクワット：\n1.後ろの足をベンチの上に乗せる。\n2.上体をできるだけ垂直に保ったまま、ゆっくりとしゃがんでいく。\n3.終わったら両足を入れ替え、同じ回数を繰り返す。",
                   
                   "腕立て：\n1.肘を曲げ、胸がつくまで体を下ろします。"]
    @State var result: String = ""

    var body: some View {
        
            VStack(spacing: 30){
                
                Spacer()
                
                // 四角形の描画
                Rectangle()
                    .foregroundColor(Color.white)
                    .shadow(radius: 10)
                // 図形の塗りつぶしに使うViewを指定
                    .frame(width:300, height:300)
                    .overlay(
                        //スワイプによる画面切り替えの実装
                        TabView{
                            Image("\(image)")
                                .resizable()
                                .frame(width:300, height:300)
                                .tabItem {
                                    Text("・")
                                }
                            Text("\(result)")
                                .tabItem {
                                    Text("・")
                                }
                           
                        }
                        //スワイプ処理の実装
                            .tabViewStyle(.page)
                        //画面下部に表示する「・」の部分
                            .indexViewStyle(
                                .page(backgroundDisplayMode: .always)
                            )
                    )
                    .border(Color.black)
                
                
                // 四角形の描画
                Rectangle()
                    .fill(Color.white)
                // 図形の塗りつぶしに使うViewを指定
                    .frame(width:300, height: 120)
                    .overlay(Text("\(setNum)セット × \(count)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    )
                    .border(Color.black)
                
                Spacer()
                
                Button {
                    //STARTボタンを押した際の処理
                    self.navigated.toggle()
                } label: {
                    // 楕円形の描画
                        Text("START")
                            .font(.largeTitle)
                            .frame(width: 360, height: 100)
                            .foregroundColor(Color(.black))
                            .background(Color(.white))
                            .cornerRadius(24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 1000)
                                    .stroke(Color(.black), lineWidth: 1.0)
                            )
            }
//                .fullScreenCover(isPresented: $navigated) {
//                    TrainingView()
//                }
                
        }
        
        Spacer()
        
            .onAppear {
                result = example.first(where: { $0.contains("\(image)") }) ?? "プランク"
            }
    }
    
}


