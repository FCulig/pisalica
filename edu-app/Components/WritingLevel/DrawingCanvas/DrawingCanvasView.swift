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

    public let viewModel: DrawingCanvasViewModel

    func updateUIViewController(_: DrawingCanvasViewController, context _: Context) {}

    func makeUIViewController(context _: Context) -> DrawingCanvasViewController {
        let viewController = DrawingCanvasViewController(viewModel: viewModel)
        return viewController
    }
}
