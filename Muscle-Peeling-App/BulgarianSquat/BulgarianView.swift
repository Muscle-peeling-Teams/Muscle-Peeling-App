import SwiftUI

struct BulgarianView: View {
    
    @ObservedObject var viewModel : SquatViewModel = .shared
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                Text("第\(viewModel.currentStageIndex)セット \((viewModel.currentStageLeaveCount))回目")
                    .font(.largeTitle)
                
                Image("plank")
                    .resizable()
                    .frame(width: 300, height: 300)
                
                HStack(spacing: 30) {
                    if !viewModel.isFinished {
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
                    }else{
                        Button {
                            dismiss()
                            viewModel.isFinished = false
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
                    }
                   
                    
                }
                
            }
            
        }
        .onAppear{
            viewModel.startPrepareTimer()
        }
    }
}
