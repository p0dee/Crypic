//
//  PictureStore.swift
//  Crypic
//
//  Created by Takeshi Tanaka on 2020/04/30.
//  Copyright © 2020 p0dee. All rights reserved.
//

import SwiftUI

class PictureStore: ObservableObject {
    
    @Published private(set) var pictures: [Picture] = []
    
    func add(image: UIImage) {
        pictures.append(Picture(image: image))
    }
    
}
