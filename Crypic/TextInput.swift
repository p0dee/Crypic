//
//  TextInput.swift
//  Crypic
//
//  Created by emp-mac-takeshitanaka on 2020/04/26.
//  Copyright © 2020 p0dee. All rights reserved.
//

import SwiftUI

struct TextInputView: View {
    
    @State var text: String = ""
    
    var body: some View {
        VStack {
            TextField("Title", text: $text)
                .background(Color.gray)
                .cornerRadius(8)            
        }.padding(.init(top: 0, leading: 40, bottom: 0, trailing: 40))
    }
    
}

struct TextInput_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView()
    }
}
