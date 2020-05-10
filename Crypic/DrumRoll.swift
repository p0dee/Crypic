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
    
    struct HeightKey: PreferenceKey {
        
        static var defaultValue: [GeoData] = []
        
        static func reduce(value: inout [Drumroll.GeoData], nextValue: () -> [Drumroll.GeoData]) {
            let next = nextValue().first!
            let existingIndex = value.firstIndex { data in
                data.id == next.id
            }
            if let index = existingIndex {
                var existingItem = value[index]
                existingItem.value = next.value
                value[index] = existingItem
            } else {
                value.append(next)
            }
        }
        
    }
    
    struct GeoData: Equatable {
        
        let id: Int
        var value: CGFloat
        
    }
    
    @State var heights: [Int : CGFloat] = [:]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            ForEach(0..<50) { index in
                VariableHeightView(id: index)
                    .frame(height: self.heights[index])
                    .onPreferenceChange(HeightKey.self) { val in
                        let existing = val.first { data in
                            data.id == index
                        }
                        self.heights[index] = existing?.value
                }
                .border(Color.blue)
            }
            
//            VariableHeightView()
//            VariableHeightView()
//            VariableHeightView()
//            ForEach(0..<10) { index in
////                Cell()
//                Text("Apple")
//                    .border(Color.red)
//                    .rotation3DEffect(.degrees(9) * Double(index), axis: (1, 0, 0))
//                    .border(Color.blue)
//            }
        }
        .background(Color.gray)
        .coordinateSpace(name: CoordinateName.baseStack)
        .frame(height: UIScreen.main.bounds.height)
        
        //.rotation3DEffect(.degrees(45), axis: (1, 0, 0)).scaleEffect(0.8).border(Color.blue)
    }
    
    struct VariableHeightView: View {
        
        struct DebugPreference: PreferenceKey {
            
            struct Value: Equatable {
                let midY: CGFloat
                let height: CGFloat
                let radian: CGFloat
            }
            
            static var defaultValue: Value = .init(midY: 0, height: 0, radian: 0)
            
            static func reduce(value: inout Value, nextValue: () -> Value) {
                value = nextValue()
            }
            
        }
        
        let wholeHeight: CGFloat = UIScreen.main.bounds.height
        let baseHeight: CGFloat = 80
        
        let id: Int
        
        var body: some View {
            VStack(spacing: 0) {
                Text("Apple\(id)")
                    .background(Color.green)
                GeometryReader { (proxy) in
                    Rectangle()
                        .fill(Color.clear)
                        .preference(key: HeightKey.self, value: [.init(id: self.id, value: self.height(proxy: proxy))])
                        .preference(key: DebugPreference.self, value: .init(midY: self.midY(proxy: proxy), height: self.height(proxy: proxy), radian: self.cosr(proxy: proxy)))
                }.frame(height: 0)
            }
            .onPreferenceChange(DebugPreference.self) { (val) in
                if self.id == 22 {
                    print("\(val)")
                }
            }
        }
        
        func midY(proxy: GeometryProxy) -> CGFloat {
            return proxy.frame(in: .named(CoordinateName.baseStack)).midY
        }
        
        func cosr(proxy: GeometryProxy) -> CGFloat {
            let r = wholeHeight * 0.5
            let midY_ = min(r, abs(midY(proxy: proxy) - r))
            let sin = min(1, midY_ / r)
            let cos = sqrt(1 - sin * sin)
            print("### id: \(id),  midY: \(midY(proxy: proxy)), sin: \(sin), cos:\(cos)")
            return cos
        }
        
        func height(proxy: GeometryProxy) -> CGFloat {
            return baseHeight * cosr(proxy: proxy)
        }
        
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
//                    .preference(key: CellHeightKey.self, value: self.calcHeight(proxy: proxy))
            }
            .font(.largeTitle)
//            .onPreferenceChange(CellHeightKey.self) {
//                print("### \($0)")
////                self.height = $0
//            }
//            .frame(height: height)
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
//            .scaleEffect(scale)
            .border(Color.blue.opacity(Double(scale)))
            .projectionEffect(.init(CATransform3DMakeRotation(CGFloat.pi / 2 * CGFloat(1 - scale), 1, 0, 0)))
//            .rotation3DEffect(.degrees(90) * Double(1 - scale), axis: (1, 0, 0))
    }
    
}

struct DrumRoll_Previews: PreviewProvider {
    static var previews: some View {
        Drumroll()
    }
}
