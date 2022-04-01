//
//  WritingLevelView.swift
//  edu-app
//
//  Created by Filip Culig on 20.03.2022..
//

import SwiftUI

// TODO: https://stackoverflow.com/questions/60700609/saving-pencilkit-image-swiftui
struct WritingLevelView: View {
    var body: some View {
        DrawingCanvasView(data: Data())
    }
}

struct WritingLevelView_Previews: PreviewProvider {
    static var previews: some View {
        WritingLevelView()
    }
}
