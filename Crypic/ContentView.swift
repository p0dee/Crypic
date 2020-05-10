//
//  ContentView.swift
//  Crypic
//
//  Created by emp-mac-takeshitanaka on 2020/04/23.
//  Copyright © 2020 p0dee. All rights reserved.
//

import SwiftUI

class MockPictureStore: PictureStore { }

struct ContentView: View {
    
    @ObservedObject var store: PictureStore
    
    @State var isPresentingImagePicker: Bool = false
    
    @State var index: Int = 0
    
    init(store: PictureStore) {
        self.store = store
        UITableView.appearance().separatorStyle = .none
    }
        
    var body: some View {
        NavigationView {
            VStack() {
                List {
                    GeometryReader { proxy in
                        Button(action: {
                            self.isPresentingImagePicker = true
                        }) {
                            Text("+").font(.largeTitle).fontWeight(.black).foregroundColor(.blue)
                        }
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                        .buttonStyle(AddButtonStyle())
                        //strokeのcontentにColor以外も入りうる?
                    }
                    .frame(height: 100)
                    //drawingGroupってなに
                    ForEach(self.store.pictures, id: \.self) { pic in
                        NavigationLink(destination: DetailView(picture: pic)) {
                            Button(action: {
                                
                            }) {
                                Text("")
                            }.buttonStyle(ImageButtonStyle(image: pic.image))
                        }
                    }
                    .frame(height: 100)
                }
            }
        }
        .sheet(isPresented: self.$isPresentingImagePicker) {
            ImagePicker(isPresenting: self.$isPresentingImagePicker, picturesStore: self.store)
        }
    }
    
    func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: MockPictureStore())
    }
}
