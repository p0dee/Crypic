//
//  Switcher.swift
//  Crypic
//
//  Created by Takeshi Tanaka on 2020/04/30.
//  Copyright © 2020 p0dee. All rights reserved.
//

import SwiftUI

struct Switcher: View {
    
    let onLabel: String
    let offLabel: String
    
    @Binding private(set) var isOn: Bool
    
    init(initialOn: Binding<Bool>, onLabel: String = "On", offLabel: String = "Off") {
        _isOn = initialOn
        self.onLabel = onLabel
        self.offLabel = offLabel
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(Color.gray)
            .frame(height: 80, alignment: .center)
            .padding(.init(top: -8, leading: -8, bottom: -8, trailing: -8))
            .background(
                ZStack {
                    Button(action: {
                        self.isOn = !self.isOn
                    }, label: {
                        HStack {
                            Text("On")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundColor(self.isOn ? .white : .gray)
                                .background(
                                    self.isOn ? Color(.black) : Color(.white)
                            )
                            Text("Off")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundColor(self.isOn ? .gray : .white)
                                .background(
                                    self.isOn ? Color(.white) : Color(.black)
                            )
                        }
                        }).clipShape(RoundedRectangle(cornerRadius: 8))
                }
        )
    }
    
}
