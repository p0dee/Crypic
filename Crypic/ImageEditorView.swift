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
    
    var doneAction: (_ result: UIImage) -> Void
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                EffectImage(image: self.$image, isOn: self.$isTakingEffect)
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                    .clipped()
            }
            Switcher(initialOn: self.$isTakingEffect)
            Spacer(minLength: 20)
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
        .padding(.init(top: 60, leading: 20, bottom: 0, trailing: 20))
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

struct EffectImage: View {
    
    @Binding var image: UIImage
    @Binding var isOn: Bool
    
    var body: some View {
        Image(uiImage: effectImage(isOn))
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    private func effectImage(_ flag: Bool) -> UIImage {
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
        ImageEditorView(image: UIImage.filledImage(size: .init(width: 200, height: 150))) { _ in }
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
