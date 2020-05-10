//
//  SegmentedControl.swift
//  Crypic
//
//  Created by Takeshi Tanaka on 2020/04/30.
//  Copyright © 2020 p0dee. All rights reserved.
//

import SwiftUI

struct SegmentedControl: View {
    
    private let cornerRadius: CGFloat = 8
    
    let labels: [String]
    
    @Binding private var selectedIndex: Int
    
    @State private var width: CGFloat = 0
    
    init(labels: [String], initialSelectedIndex: Binding<Int>) {
        self.labels = labels
        _selectedIndex = initialSelectedIndex
    }
    
    private func isLastElement(_ index: Int) -> Bool {
        return labels.count - 1 == index
    }
    
    private func isSelected(_ index: Int) -> Bool {
        return index == selectedIndex
    }
    
    private func adjoiningIndicesForSeparator(_ index: Int) -> [Int] {
        return [index, index + 1]
    }
    
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .background(
                HStack(spacing: 0) {
                    ForEach(self.labels.indices) { index in
                        HStack(spacing: 0) { //Grpupだと、タッチイベントに対する再描画が行われない(onTapGestureは反応する)
                            Label(text: self.labels[index], isSelected: self.isSelected(index))
                            if !self.isLastElement(index) {
                                Separator(self.adjoiningIndicesForSeparator(index), selectedIndex: self.$selectedIndex)
                                    .padding(.init(top: 6, leading: 0, bottom: 6, trailing: 0))
                                    .frame(width: 1)
                            }
                        }
                        .animation(.interactiveSpring(response: 0.25, dampingFraction: 1.0))
                        .anchorPreference(key: BoundsKey.self, value: .bounds) { anchor in
                            return self.selectedIndex == index ? anchor : nil
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.selectedIndex = index
                        }
                    }
                }
                .backgroundPreferenceValue(BoundsKey.self) { anchor in
                    GeometryReader { proxy in
                        RoundedRectangle(cornerRadius: self.cornerRadius - 2)
                            .fill(Color.white)
                            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.15), radius: 2, y: 1)
                            .padding(.init(top: 2, leading: 2, bottom: 2, trailing: 2))
                            .frame(width: proxy[anchor!].width, height: proxy[anchor!].height)
                            .offset(x: proxy[anchor!].minX, y: proxy[anchor!].minY)
                            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .leading)
                            
                            .animation(.interactiveSpring(response: 0.25, dampingFraction: 1.0))
                            .handleProxy(proxy) { (proxy) in
                                DispatchQueue.main.async {
                                    self.width = proxy.size.width
                                }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .background(
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                        .fill(Color(white: 0.0, opacity: 0.15))
                )
        )
            .frame(height: 30)
            .gesture(DragGesture(minimumDistance: 0).onChanged({ (value) in
                let locationX = value.location.x
                let cellWidth = self.width / CGFloat(self.labels.count)
                let index = Int(floor(locationX / cellWidth))
                self.selectedIndex = index
            }))
    }
    
}

private extension SegmentedControl {
    
    struct BoundsKey: PreferenceKey {
        
        static var defaultValue: Anchor<CGRect>? = nil
        
        static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
            value = value ?? nextValue()
        }
        
    }
    
}

private extension SegmentedControl {
    
    struct Label: View {
        
        let text: String
        let isSelected: Bool
        
        var body: some View {
            ZStack(alignment: .center) {
                Text(self.text)
                    .font(.system(size: 13, weight: .regular))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.black)
                    .opacity(self.isSelected ? 0.0 : 1.0)
                Text(self.text)
                    .font(.system(size: 13, weight: .semibold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.black)
                    .opacity(self.isSelected ? 1.0 : 0.0)
            }
        }
        
    }
    
    struct Separator: View {
        
        var adjoiningIndices: [Int]
        
        @Binding var selectedIndex: Int
        
        init(_ adjoiningIndices: [Int], selectedIndex: Binding<Int>) {
            self.adjoiningIndices = adjoiningIndices
            _selectedIndex = selectedIndex
        }
        
        var body: some View {
            Rectangle()
                .fill(adjoiningIndices.contains(selectedIndex) ? Color.clear : Color.black)
        }
        
    }
    
}

private extension View {
    
    func handleProxy(_ proxy: GeometryProxy, handler: (GeometryProxy) -> ()) -> some View {
        handler(proxy)
        return self
    }
    
}

struct SegmentedControl_Previews: PreviewProvider {
    
    static var previews: some View {
        SegmentedControl(labels: ["One", "Two", "Three", "Four"], initialSelectedIndex: .constant(0))
            .previewLayout(.sizeThatFits)
            .padding()
    }
    
}
