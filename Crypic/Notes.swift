//
//  Notes.swift
//  Crypic
//
//  Created by emp-mac-takeshitanaka on 2020/05/07.
//  Copyright © 2020 p0dee. All rights reserved.
//

/**
 //
 //  DrumRoll.swift
 //  Crypic
 //
 //  Created by Takeshi Tanaka on 2020/05/02.
 //  Copyright © 2020 p0dee. All rights reserved.
 //

 import SwiftUI

 struct Drumroll: View {
     
     enum CoordinateName: String {
         case baseStack
     }
     
     var body: some View {
         ScrollView(.vertical, showsIndicators: true) {
             ForEach(0..<10) { _ in
                 Cell()
             }
         }
         .background(Color.gray)
         .coordinateSpace(name: CoordinateName.baseStack)
 //        .frame(height: 200)
         .border(Color.red)
         
         //.rotation3DEffect(.degrees(45), axis: (1, 0, 0)).scaleEffect(0.8).border(Color.blue)
     }
     
     struct Cell: View {
         
         struct CellHeightKey: PreferenceKey {
             
             static var defaultValue: CGFloat? = 0
             
             static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
                 value = value ?? nextValue()
             }
             
         }
         
         @State var height: CGFloat?
         
         var body: some View {
 //            Text("Apple").font(.largeTitle).border(Color.blue)
             GeometryReader { proxy in
                 Text("Apple")
                     .translate(proxy: proxy)
                     .preference(key: CellHeightKey.self, value: self.calcHeight(proxy: proxy))
             }
             .font(.largeTitle)
             .onPreferenceChange(CellHeightKey.self) {
                 print("### \($0)")
 //                self.height = $0
             }
             .frame(height: height)
         }
         
         func calcHeight(proxy: GeometryProxy) -> CGFloat {
             let frame = proxy.frame(in: .named(Drumroll.CoordinateName.baseStack))
             let midY = frame.midY
             let scale = (150 - abs(midY - 150)) / 150
             return 40 * scale
         }
         
         func scaleText(proxy: GeometryProxy) -> String {
             let frame = proxy.frame(in: .named(Drumroll.CoordinateName.baseStack))
             let midY = frame.midY
             let scale = (150 - abs(midY - 150)) / 150
             return "\(scale)"
         }
         
     }
     
 }

 extension View {
     
     func translate(proxy: GeometryProxy) -> some View {
         let frame = proxy.frame(in: .named(Drumroll.CoordinateName.baseStack))
         let midY = frame.midY
         let scale = (150 - abs(midY - 150)) / 150
         return self
 //            .frame(height: 40 * scale)
             .scaleEffect(scale)
             .border(Color.blue)
             .projectionEffect(.init(CATransform3DMakeRotation(CGFloat.pi / 2 * CGFloat(1 - scale), 1, 0, 0)))
 //            .rotation3DEffect(.degrees(90) * Double(1 - scale), axis: (1, 0, 0))
     }
     
 }

 struct DrumRoll_Previews: PreviewProvider {
     static var previews: some View {
         Drumroll()
     }
 }

 */
