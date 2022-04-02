//
//  NewDrawingCanvasViewController.swift
//  edu-app
//
//  Created by Filip Culig on 31.03.2022..
//

import Combine
import MLKit
import UIKit

class DrawingCanvasViewController: UIViewController {
    private enum Constants {
        static let brushWidth: CGFloat = 10
    }

    // MARK: - View components -

    private lazy var drawnImage = UIImageView()

    // MARK: - Private properties -

    private let viewModel: DrawingCanvasViewModel
    private var cancellabels: Set<AnyCancellable> = []

    // MARK: - Initializers -

    public init(viewModel: DrawingCanvasViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        subscribeActions()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        let touch = touches.first
        viewModel.touchesBegan(touchPoint: touch!.location(in: drawnImage), time: touch!.timestamp)
        drawLineSegment(touch: touch)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        let touch = touches.first
        viewModel.touchesMoved(time: touch!.timestamp)
        drawLineSegment(touch: touch)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        let touch = touches.first
        viewModel.touchesEnded(time: touch!.timestamp)
        drawLineSegment(touch: touch)
    }
}

// MARK: - Subscribing actions -

private extension DrawingCanvasViewController {
    func subscribeActions() {
        viewModel.clearCanvas
            .sink { [weak self] in self?.drawnImage.image = nil }
            .store(in: &cancellabels)
    }
}

// MARK: - View setup -

private extension DrawingCanvasViewController {
    func addSubviews() {
        view.addSubview(drawnImage)
        drawnImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drawnImage.topAnchor.constraint(equalTo: view.topAnchor),
            drawnImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            drawnImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            drawnImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            drawnImage.heightAnchor.constraint(equalToConstant: 700),
        ])
    }
}

private extension DrawingCanvasViewController {
    func drawLineSegment(touch: UITouch!) {
        let currentPoint = touch.location(in: drawnImage)

        UIGraphicsBeginImageContext(drawnImage.frame.size)
        drawnImage.image?.draw(
            in: CGRect(
                x: 0, y: 0, width: drawnImage.frame.size.width, height: drawnImage.frame.size.height
            ))
        let ctx: CGContext! = UIGraphicsGetCurrentContext()
        ctx.move(to: viewModel.lastPoint)
        ctx.addLine(to: currentPoint)
        ctx.setLineCap(CGLineCap.round)
        ctx.setLineWidth(Constants.brushWidth)
        // Unrecognized strokes are drawn in blue.
        ctx.setStrokeColor(red: 0, green: 0, blue: 1, alpha: 1)
        ctx.setBlendMode(CGBlendMode.normal)
        ctx.strokePath()
        ctx.flush()
        drawnImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        viewModel.lastPoint = currentPoint
    }
}
