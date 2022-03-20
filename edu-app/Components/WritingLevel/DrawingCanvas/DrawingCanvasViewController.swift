//
//  DrawingCanvasViewController.swift
//  edu-app
//
//  Created by Filip Culig on 20.03.2022..
//

import SwiftUI
import PencilKit

// MARK: - DrawingCanvasViewController -
class DrawingCanvasViewController: UIViewController {
    
    // MARK: - View components -
    
    private lazy var canvas: PKCanvasView = {
        let view = PKCanvasView()
        view.drawingPolicy = .anyInput
        view.minimumZoomScale = 1
        view.maximumZoomScale = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tool = inkingTool
        return view
    }()
    
    // MARK: - Public properties -
    
    var drawingData = Data()
    var drawingChanged: (Data) -> Void = { _ in}
    
    // MARK: - Private properties -
    
    private let inkingTool = PKInkingTool(PKInkingTool.InkType.pen, color: .black, width: 10)

    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(canvas)
        NSLayoutConstraint.activate([
            canvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            canvas.topAnchor.constraint(equalTo: view.topAnchor),
            canvas.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        canvas.delegate = self
        canvas.becomeFirstResponder()
    }
    
}

// MARK: - PKCanvasViewDelegate -

extension DrawingCanvasViewController: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        print("Drawing changed")
        drawingChanged(canvasView.drawing.dataRepresentation())
    }
}

// MARK: - PKToolPickerObserver -

extension DrawingCanvasViewController: PKToolPickerObserver { }
