//
//  ImagePicker.swift
//  Crypic
//
//  Created by emp-mac-takeshitanaka on 2020/04/23.
//  Copyright © 2020 p0dee. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = PickerCoordinator
    
    @Binding var isPresenting: Bool
    var picturesStore: PictureStore
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> PickerCoordinator {
        return PickerCoordinator(isShown: $isPresenting, picturesStore: picturesStore)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.delegate = context.coordinator
        return vc
    }
    
}

extension ImagePicker {
    
    class PickerCoordinator: NSObject {
        
        @Binding var isPickerPresenting: Bool
        var picturesStore: PictureStore
            
        init(isShown: Binding<Bool>, picturesStore: PictureStore) {
            _isPickerPresenting = isShown
            self.picturesStore = picturesStore
        }
        
    }
    
}

extension ImagePicker.PickerCoordinator: UINavigationControllerDelegate { }

extension ImagePicker.PickerCoordinator: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let imageEditor = ImageEditorView(image: uiImage) { [weak self] result in
            self?.isPickerPresenting = false
            self?.picturesStore.add(image: result)
        }
        let host = UIHostingController(rootView: imageEditor)
        picker.pushViewController(host, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isPickerPresenting = false
    }
    
}
