//
//  ButtonStyles.swift
//  Crypic
//
//  Created by Takeshi Tanaka on 2020/04/30.
//  Copyright © 2020 p0dee. All rights reserved.
//

import SwiftUI

struct ImageButtonStyle: ButtonStyle {
    
    let image: UIImage
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { proxy in
            Image(uiImage: self.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .cornerRadius(8)
                .clipped()
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }
    
}

struct AddButtonStyle: ButtonStyle {
    
    var foreground = Color.white
    var background = Color.blue

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { proxy in
            configuration.label
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 6).fill(Color.blue)
                )
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .contentShape(Rectangle()) //ButtonStyle側につける
        }
    }
    
}
