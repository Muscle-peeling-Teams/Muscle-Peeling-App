////
////  PopupView.swift
////  Muscle-Peeling-App
////
////  Created by cmStudent on 2022/09/16.
////
//
//import SwiftUI
//
////extension PopUpDialogView {
////
////    init(isPresented: Binding<Bool>,
////         btnTapClose: Bool = true,
////         @ViewBuilder _ content: () -> Content) {
////        _isPresented = isPresented
////        self.btnTapClose = btnTapClose
////        self.content = content()
////    }
////}
//
//struct PopupDialogView: View {
//    //ポップアップダイアログの表示可否
//    @Binding var isPresented: Bool
//    //ダイアログの中に埋め込むContent
//    //let content: Content
//    //ダイアログの背景をタップしても画面を閉じることが出来るか
//    let btnTapClose: Bool
//
//    private let buttonSize: CGFloat = 24
//
//    var body: some View {
//
//        //ダイアログのサイズの調整
//        GeometryReader{ proxy in
//            let dialogWidth = proxy.size.width * 0.75
//
//            ZStack{
//                //ポップアップ時の背景となるView、今回の場合は3の画面。
//                //TestBackView(color: .gray.opacity(0.7))
//                    .onTapGesture {
//                        if btnTapClose {
//                            withAnimation {
//                                isPresented = false
//                            }
//                        }
//                    }
//
//                //testContent
//                    .frame(width: dialogWidth)
//                    .padding()
//                    .padding(.top, buttonSize)
//                    .background(.white)
//                    .cornerRadius(12)
//                    //閉じるボタン
//                    .overlay(alignment: .topTrailing) {
//
//                        CloseButton(fontSize: buttonSize,
//                                    weight: .bold,
//                                    color: .gray.opacity(0.7)) {
//                            withAnimation {
//                                isPresented = false
//                            }
//                        }
//                                    .padding(4)
//                    }
//            }
//        }
//    }
//}
//
////struct PopupDialogView_Previews: PreviewProvider {
////    static var previews: some View {
////        PopupDialogView(isPresented: .constant(true)){
////            Text("Something")
////        }
////    }
////}
