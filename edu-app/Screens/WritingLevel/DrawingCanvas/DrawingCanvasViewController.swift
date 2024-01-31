//
//  NewDrawingCanvasViewController.swift
//  edu-app
//
//  Created by Filip Culig on 31.03.2022..
//

import Combine
//import Lottie
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

//    private lazy var animationView = LottieAnimationView(name: "confetti")

    // MARK: - Private properties -

    private let viewModel: DrawingCanvasViewModel
    private var cancellabels: Set<AnyCancellable> = []

    // MARK: - Initializers -

    public init(viewModel: DrawingCanvasViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        subscribeActions()
    }

    @available(*, unavailable) required init?(coder _: NSCoder) {
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

        viewModel.onWordCorrect
            .sink { [weak self] in
//                self?.animationView.play()
                self?.removeAllDrawnImages()
            }
            .store(in: &cancellabels)
    }
}

// MARK: - View setup -

private extension DrawingCanvasViewController {
    func addSubviews() {
        view.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false

//        view.addSubview(animationView)
//        animationView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),

//            animationView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
//            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
//            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])

        addDrawnImageSubview(drawnImage)
        view.backgroundColor = .clear
    }

    func addDrawnImageSubview(_ image: UIImageView) {
        background.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: background.topAnchor, constant: 10),
            image.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -10),
            image.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10),
            image.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -10),
        ])
    }

    func removeAllDrawnImages() {
        background.subviews.forEach { $0.removeFromSuperview() }
        view.subviews.forEach { $0.removeFromSuperview() }
        addSubviews()
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
        UIView.animate(withDuration: 1) { [weak self] in
            self?.background.backgroundColor = .red
            self?.background.backgroundColor = .clear
        }
    }

    func displaySuccess() {
        UIView.animate(withDuration: 1) { [weak self] in
            self?.background.backgroundColor = .green
            self?.background.backgroundColor = .clear
        }

        guard viewModel.level.isWord else { return }

        let imageView = UIImageView()
        imageView.image = drawnImage.image
        addDrawnImageSubview(imageView)
    }
}
