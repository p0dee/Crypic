//
//  ImageEditingView.swift
//  Crypic
//
//  Created by emp-mac-takeshitanaka on 2020/04/26.
//  Copyright © 2020 p0dee. All rights reserved.
//

import SwiftUI
import CoreGraphics

struct ImageEditorView: View {
    
    @State var image: UIImage
    
    @State var isTakingEffect: Bool = false
    
    @State var selectedIndex: Int = 0
    
    var doneAction: (_ result: UIImage) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            EffectImage(image: self.$image, isOn: self.$isTakingEffect)
            Spacer(minLength: 20)
            SegmentedControl(labels: ["One", "Two", "Three", "Four", "Five"], initialSelectedIndex: $selectedIndex)
            Spacer().layoutPriority(1)
            Button(action: {
                self.doneAction(self.image)
            }) {
                Text("Done")
                    .padding(.init(top: 10, leading: 60, bottom: 10, trailing: 60))
                    .background(Color(.systemBlue))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding(.init(top: 20, leading: 20, bottom: 0, trailing: 20))
    }
    
}

struct Effect {
    
    func effectImage(_ image: UIImage) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return image }
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(ciImage, forKey: "inputImage")
        guard let output = filter?.outputImage else {
            return image }
        guard let cgImage = CIContext().createCGImage(output, from: output.extent) else { return image }
        
        return UIImage(cgImage: cgImage)
    }
    
}

struct ImageView: View {
    
    struct HeightPreference: PreferenceKey {
        
        static var defaultValue: CGFloat = 0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
        
    }
    
    @State private var height: CGFloat = 0
    
    @Binding var image: UIImage
    
    var body: some View {
        GeometryReader { proxy in
            Image(uiImage: self.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: proxy.size.width)
                .preference(key: HeightPreference.self, value: self.height(width: proxy.size.width))
        }
        .frame(height: height)
        .onPreferenceChange(HeightPreference.self) { (value) in
            self.height = value
        }
    }
    
    private func height(width: CGFloat) -> CGFloat {
        return image.size.height * width / image.size.width
    }
    
}

struct EffectImage: View {
    
    @Binding var image: UIImage
    @Binding var isOn: Bool
    
    @State private var height: CGFloat = 0
    
    struct HeightPreference: PreferenceKey {
        
        static var defaultValue: CGFloat = 0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
        
    }
    
    var body: some View {
//        GeometryReader { proxy in
//            Image(uiImage: self.effectImage(self.isOn))
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: proxy.size.width)
//                .preference(key: HeightPreference.self, value: self.height(width: proxy.size.width))
//        }
//        .frame(height: height)
//        .onPreferenceChange(HeightPreference.self) { (value) in
//            self.height = value
//        }
        ImageView(image: $image)
    }
    
    private func height(width: CGFloat) -> CGFloat {
        return image.size.height * width / image.size.width
    }
    
    private func effectImage(_ flag: Bool) -> UIImage {
        return image
        if !flag { return image }
        guard let ciImage = CIImage(image: image) else { return image }
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(ciImage, forKey: "inputImage")
        guard let output = filter?.outputImage else {
            return image }
        guard let cgImage = CIContext().createCGImage(output, from: output.extent) else { return image }
        return UIImage(cgImage: cgImage)
    }
    
}

struct ImageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ImageEditorView(image: UIImage.filledImage(size: .init(width: 200, height: 200))) { _ in }
    }
}

private extension UIImage {
    
    static func filledImage(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { fatalError() }
        UIColor.yellow.setFill()
        ctx.addRect(.init(origin: .zero, size: size))
        ctx.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
