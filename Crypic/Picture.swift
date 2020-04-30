//
//  Picture.swift
//  Crypic
//
//  Created by Takeshi Tanaka on 2020/04/30.
//  Copyright © 2020 p0dee. All rights reserved.
//

import UIKit

struct Picture {
    
    let image: UIImage
    
}

extension Picture: Identifiable, Hashable {
    
    typealias ID = String
    
    var id: ID {
        return "\(image.hash)"
    }
    
}
