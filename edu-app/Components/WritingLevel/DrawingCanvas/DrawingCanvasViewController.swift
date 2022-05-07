//
//  NewDrawingCanvasViewController.swift
//  edu-app
//
//  Created by Filip Culig on 31.03.2022..
//

import Combine
import MLKit
import UIKit

// MARK: - DrawingCanvasViewController -

class DrawingCanvasViewController: UIViewController {
    // MARK: - Constants -

    private enum Constants {
        static let brushWidth: CGFloat = 10
    }

    // MARK: - View components -

    private lazy var background = UIView()
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

        viewModel.errorNotification
            .sink { [weak self] in self?.displayError() }
            .store(in: &cancellabels)

        viewModel.successNotification
            .sink { [weak self] in self?.displaySuccess() }
            .store(in: &cancellabels)
    }
}

// MARK: - View setup -

private extension DrawingCanvasViewController {
    func addSubviews() {
        view.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false

        background.addSubview(drawnImage)
        drawnImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            drawnImage.topAnchor.constraint(equalTo: background.topAnchor, constant: 10),
            drawnImage.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -10),
            drawnImage.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10),
            drawnImage.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -10),
        ])

        view.backgroundColor = .white
    }
}

// MARK: - Utils -

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
        ctx.setStrokeColor(red: viewModel.strokeColor.rgba.red,
                           green: viewModel.strokeColor.rgba.green,
                           blue: viewModel.strokeColor.rgba.blue,
                           alpha: viewModel.strokeColor.rgba.alpha)
        ctx.setBlendMode(CGBlendMode.normal)
        ctx.strokePath()
        ctx.flush()
        drawnImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        viewModel.lastPoint = currentPoint
    }

    func displayError() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.background.backgroundColor = .red
            self?.background.backgroundColor = .white
        }
    }

    func displaySuccess() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.background.backgroundColor = .green
            self?.background.backgroundColor = .white
        }
    }
}
