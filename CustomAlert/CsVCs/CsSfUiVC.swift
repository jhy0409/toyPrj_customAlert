//
//  CsXibVC.swift
//  CustomAlert
//
//  Created by inooph on 2023/08/24.
//

import SwiftUI
import UIKit

struct CsSfUiVC: View, PrBtnLayout {
    var isDefPair: btnLayout = .withinZroIdx
    
    var btnTitleArr: [String] = []
    var btnTitArr: [btnTitle] = []
    
    var titMsgViewFull: CGFloat = 1.0
    var titMsgViewMax: CGFloat  = 0.6
    
    @Environment(\.dismiss) var dismiss
    
    @State var didAppear: Bool = false {
        willSet { print("--> didAppear = \(newValue)\n")}
    }
    
    var nxtBgCol: Color {
        didAppear ? .primary.opacity(0.35) : .clear
    }
    
    var artTp: (title: String, msg: String) = ("title title title ", "desc desc desc")
    
    var tblCellIsOverView: Bool {
        return viewSize.height - (viewSize.height * titMsgViewMax) - totalCellHgt < 0
    }
    
    var tblMxHeight: CGFloat {
        return viewSize.height * (1.0 - titMsgViewMax)
    }
    
    var totalCellHgt: CGFloat {
        return CGFloat(btnTitArr.count) * defCellHgt
    }
    
    
    var body: some View {
        
        ZStackLayout(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
            VStack(spacing: 0) {
                
                ScrollView(.vertical, showsIndicators: true) {
                    Text("\(artTp.title)")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 40)
                    
                    Text("\(artTp.msg)")
                        .foregroundColor(.black)
                        .fontWeight(.regular)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                }.frame(maxHeight: viewSize.height * ( tblCellIsOverView ? titMsgViewMax : 0.2) )

                if totalCellHgt > 0 {
                    Divider()
                }
                List(btnTitArr) { item in
                    rowView(didAppear: $didAppear, btnIdxs: item.btnIdxs)
                        .alignmentGuide(.listRowSeparatorLeading) { dms in
                            return -dms.width
                        }
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                        .frame(height: 50)
                }
                .frame(height: tblCellIsOverView ? tblMxHeight : totalCellHgt )
                .listStyle(.plain)
                
            }
            .frame(width: (viewSize.width * 0.85))
            //.padding(.vertical, 25)
            //.padding(.horizontal, 30)
            .background(BlurView())
            .cornerRadius(25)
            
            Button(action: {
                withAnimation {
                    didAppear.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        dismiss()
                    }
                }
                
            }) {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 28, weight: .regular))
                
            }.padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(nxtBgCol)
        .animation(.linear(duration: 0.3), value: nxtBgCol)

        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                didAppear.toggle()
            }
        }
        
    }

    
}

struct rowView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var didAppear: Bool
    
    var btnIdxs: (prv: Int?, nxt: Int?)?
    
    var prvStr: String {
        guard let prv = btnIdxs?.prv else { return "" }
        return String(describing: prv)
    }
    
    var nxtStr: String {
        guard let nxt = btnIdxs?.nxt else { return "" }
        return String(describing: nxt)
    }
    
    
    var body: some View {
        HStack(alignment: .center) {
            Button(prvStr, action: {
                
            })
            .frame(maxWidth: .infinity)
            .onTapGesture {
                print("--> tapped \(prvStr)")
                didAppear = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    dismiss()
                }
            }
            
            if nxtStr.isEmpty == false {
                Divider()
                Button( nxtStr, action: {
                })
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    print("--> tapped \(nxtStr)")
                    didAppear = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    
}

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CsSfUiVC()
    }
}

struct btnTitle: Identifiable {
    var id = UUID()
    var btnIdxs: (prv: Int?, nxt: Int?)?
}

extension View {
    var viewSize: CGSize {
        return .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}
