import SwiftUI

struct BulgarianView: View {
    
    @ObservedObject var viewModel : SquatViewModel = .shared
    @State var shiftMenu = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack{
            VStack{
                Spacer()
                Text("第\(viewModel.sqtrainingSetCount)セット 残り\(Int((viewModel.sqsettingCount) - (viewModel.sqtrainingCount)))回")
                    .font(.largeTitle)
                
                Image("ブルガリアンスクワット")
                    .resizable()
                    .frame(width: 300, height: 300)
                
                if viewModel.sqtrainingFinished == false{
                    
                    HStack(spacing: 30) {
                        VStack {
                            Spacer()
                            Text("一時停止")
                            Button(action: {
                                if viewModel.sqtrainingFinished == false{
                                    viewModel.pauseTraining()
                                }else{
                                    //終了時には反応させない
                                }
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
                }else{
                    Button {
                        dismiss()
                        dismiss()
                    } label: {
                        // 楕円形の描画
                        Text("お疲れさまです")
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
                    Spacer()
                }
            }
        }
        .onAppear{
            viewModel.sqtrainingFinished = false
            viewModel.legChangeCount = 0
            viewModel.sqtrainingCount = 1
            viewModel.sqtrainingSetCount = 1
            viewModel.squatReady()
            viewModel.sqpauseNum = 3
        }
    }
}
