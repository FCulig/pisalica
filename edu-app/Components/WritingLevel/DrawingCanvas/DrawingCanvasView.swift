//
//  DrawingCanvasView.swift
//  edu-app
//
//  Created by Filip Culig on 20.03.2022..
//

import PencilKit
import SwiftUI

// MARK: - DrawingCanvasView -

struct DrawingCanvasView: UIViewControllerRepresentable {
    typealias UIViewControllerType = DrawingCanvasViewController

    var data: Data

    func updateUIViewController(_: DrawingCanvasViewController, context _: Context) {
//        viewController.drawingData = data
    }

    func makeUIViewController(context _: Context) -> DrawingCanvasViewController {
        let viewController = DrawingCanvasViewController()
//        viewController.drawingData = data
//        viewController.drawingChanged = { data in
//            print("Something changed")
//        }

        return viewController
    }
}
