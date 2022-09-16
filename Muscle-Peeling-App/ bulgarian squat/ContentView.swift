import SwiftUI

struct ContentView: View {
   
    @ObservedObject var viewModel : ViewModel = .shared
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                Text("第\(viewModel.setCount)セット \((viewModel.num))回目")
                    .font(.largeTitle)
                
                Image("plank")
                    .resizable()
                    .frame(width: 300, height: 300)
                
                HStack(spacing: 30) {
                    VStack {
                        Spacer()
                        Text("一時停止")
                        Button(action: {
                            viewModel.pauseTraining()
                        }) {
                            Text("| |")
                                .font(.largeTitle)
                                .bold()
                                .padding()
                                .frame(width: 100, height: 100)
                            
                                .foregroundColor(Color.black)
                                .overlay(
                                    Circle()
                                        .stroke(Color.yellow, lineWidth: 3)
                                )
                        }
                        Spacer()
                    }
                    VStack {
                        Text("中止")
                        Button(action: {
                            viewModel.stopTraining()
                        }) {
                            Text("■")
                                .font(.largeTitle)
                                .bold()
                                .padding()
                                .frame(width: 100, height: 100)
                            
                                .foregroundColor(Color.black)
                                .overlay(
                                    Circle()
                                        .stroke(Color.red, lineWidth: 3)
                                )
                        }
                    }
                    
                }
                
            }
            
        }
               
    }
    }

//        .onAppear{
//           viewModel.startTimer()
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

