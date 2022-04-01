//
//  NewDrawingCanvasViewController.swift
//  edu-app
//
//  Created by Filip Culig on 31.03.2022..
//

import MLKit
import UIKit

/// The `ViewController` manages the display seen by the user. The drawing canvas is actually two
/// overlapping image views. The top one contains the ink that the user is drawing before it is sent
/// to the recognizer. It can be thought of as a temporary buffer for ink in progress. When the user
/// presses the "Recognize" button, the ink is transferred to the other canvas, which displays a
/// grayed out version of the ink together with the recognition result.
///
/// The management of the interaction with the recognizer happens in `StrokeManager`.
/// `ViewController` just takes care of receiving user events, rendering the temporary ink, and
/// handles redraw requests from the `StrokeManager` when the ink is recognized. This latter request
/// comes through the `StrokeManagerDelegate` protocol.
///
/// The `ViewController` provides a number of buttons for controlling the `StrokeManager` which allow
/// for selecting the recognition language, downloading or deleting the recognition model, triggering
/// recognition, and clearing the ink.
@objc(DrawingCanvasViewController)
class DrawingCanvasViewController: UIViewController {
    // MARK: - View components -

    /** This view displays all the ink that has been sent for recognition, and recognition results. */
    private lazy var recognizedImage = UIImageView()

    /** This view shows only the ink that is currently being drawn, before sending for recognition. */
    private lazy var drawnImage = UIImageView()

    private lazy var imagesContainer = UIView()

    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didPressClear), for: .touchUpInside)
        button.setTitle("Clear", for: .normal)
        return button
    }()

    private lazy var recognizeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didPressRecognize), for: .touchUpInside)
        button.setTitle("Recognize", for: .normal)
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [clearButton, recognizeButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imagesContainer, buttonsStackView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Private properties -

    /** Constant defining how to render strokes. */
    private var kBrushWidth: CGFloat = 2.0

    /** All possible language tags supported by the digital ink recognition API. */
    private var allLanguageTags: [String] = []

    /** Mapping between the langugae tags and their display names. */
    private var languageTagDisplayNames: [String: String] = [:]

    /** Default language selected when demo app starts up. */
    private var defaultLanguage: String = ""

    /**
     * Object that takes care of the logic of saving the ink, sending ink to the recognizer after a
     * long enough pause, and storing the recognition results.
     */
    private var strokeManager: StrokeManager!

    /** Coordinates of the previous touch point as the user is drawing ink. */
    private var lastPoint: CGPoint!

    // MARK: - Lifecycle -

    /** Initializes the view, in turn creating the StrokeManager and recognizer. */
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()

        // Create a `StrokeManager` to store the drawn ink. This also creates the recognizer object.
        strokeManager = StrokeManager(delegate: self)
        strokeManager!.selectLanguage(languageTag: "hr")
    }

    /** Handle start of stroke: Draw the point, and pass it along to the `StrokeManager`. */
    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        let touch = touches.first
        // Since this is a new stroke, make last point the same as the current point.
        lastPoint = touch!.location(in: drawnImage)
        let time = touch!.timestamp
        drawLineSegment(touch: touch)
        strokeManager!.startStrokeAtPoint(point: lastPoint!, t: time)
    }

    /** Handle continuing a stroke: Draw the line segment, and pass along to the `StrokeManager`. */
    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        let touch = touches.first
        drawLineSegment(touch: touch)
        strokeManager!.continueStrokeAtPoint(point: lastPoint!, t: touch!.timestamp)
    }

    /** Handle end of stroke: Draw the line segment, and pass along to the `StrokeManager`. */
    override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        let touch = touches.first
        drawLineSegment(touch: touch)
        strokeManager!.endStrokeAtPoint(point: lastPoint!, t: touch!.timestamp)
    }
}

// MARK: - View setup -

private extension DrawingCanvasViewController {
    func addSubviews() {
        imagesContainer.addSubview(drawnImage)
        drawnImage.translatesAutoresizingMaskIntoConstraints = false

        imagesContainer.addSubview(recognizedImage)
        recognizedImage.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            drawnImage.topAnchor.constraint(equalTo: imagesContainer.topAnchor),
            drawnImage.bottomAnchor.constraint(equalTo: imagesContainer.bottomAnchor),
            drawnImage.leadingAnchor.constraint(equalTo: imagesContainer.leadingAnchor),
            drawnImage.trailingAnchor.constraint(equalTo: imagesContainer.trailingAnchor),

            recognizedImage.topAnchor.constraint(equalTo: imagesContainer.topAnchor),
            recognizedImage.bottomAnchor.constraint(equalTo: imagesContainer.bottomAnchor),
            recognizedImage.leadingAnchor.constraint(equalTo: imagesContainer.leadingAnchor),
            recognizedImage.trailingAnchor.constraint(equalTo: imagesContainer.trailingAnchor),

            imagesContainer.heightAnchor.constraint(equalToConstant: 700),
        ])
    }
}

// MARK: - Button tap handling -

private extension DrawingCanvasViewController {
    /** Clear button clears the canvases and also tells the `StrokeManager` to delete everything. */
    @objc func didPressClear() {
        recognizedImage.image = nil
        drawnImage.image = nil
        strokeManager!.clear()
        displayMessage(message: "")
    }

    /** Relays the recognize ink command to the `StrokeManager`. */
    @objc func didPressRecognize() {
        strokeManager!.recognizeInk()
    }
}

private extension DrawingCanvasViewController {
    /** Invoked by the language picker to get the number of components. */
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    /**
     * Draws a line segment from `self.lastPoint` to the current touch point given in the argument
     * to the temporary ink canvas.
     */
    func drawLineSegment(touch: UITouch!) {
        let currentPoint = touch.location(in: drawnImage)

        UIGraphicsBeginImageContext(drawnImage.frame.size)
        drawnImage.image?.draw(
            in: CGRect(
                x: 0, y: 0, width: drawnImage.frame.size.width, height: drawnImage.frame.size.height
            ))
        let ctx: CGContext! = UIGraphicsGetCurrentContext()
        ctx.move(to: lastPoint!)
        ctx.addLine(to: currentPoint)
        ctx.setLineCap(CGLineCap.round)
        ctx.setLineWidth(kBrushWidth)
        // Unrecognized strokes are drawn in blue.
        ctx.setStrokeColor(red: 0, green: 0, blue: 1, alpha: 1)
        ctx.setBlendMode(CGBlendMode.normal)
        ctx.strokePath()
        ctx.flush()
        drawnImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        lastPoint = currentPoint
    }

    /** Given an `Ink`, draw it into the `recognizedImage` canvas in gray. */
    func drawInk(ink: Ink) {
        UIGraphicsBeginImageContext(drawnImage.frame.size)
        recognizedImage.image?.draw(
            in: CGRect(
                x: 0, y: 0, width: drawnImage.frame.size.width, height: drawnImage.frame.size.height
            ))
        let ctx: CGContext! = UIGraphicsGetCurrentContext()
        for stroke in ink.strokes {
            if stroke.points.isEmpty {
                continue
            }
            let point = CGPoint(x: Double(stroke.points[0].x), y: Double(stroke.points[0].y))
            ctx.move(to: point)
            ctx.addLine(to: point)
            for point in stroke.points {
                ctx.addLine(to: CGPoint(x: Double(point.x), y: Double(point.y)))
            }
        }
        ctx.setLineCap(CGLineCap.round)
        ctx.setLineWidth(kBrushWidth)
        // Recognized strokes are drawn in gray.
        ctx.setStrokeColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        ctx.setBlendMode(CGBlendMode.normal)
        ctx.strokePath()
        ctx.flush()
        recognizedImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    /** Given an `Ink`, returned the bounding box of the ink. */
    func getInkRect(ink: Ink) -> CGRect {
        var rect = CGRect.null
        if ink.strokes.count == 0 {
            return rect
        }
        for stroke in ink.strokes {
            for point in stroke.points {
                rect = rect.union(CGRect(x: Double(point.x), y: Double(point.y), width: 0, height: 0))
            }
        }
        // Make the minimum size 10x10 pixels.
        rect = rect.union(
            CGRect(
                x: rect.midX - 5,
                y: rect.midY - 5,
                width: 10,
                height: 10
            ))
        return rect
    }

    /**
     * Given a `recognizedInk`, compute the bounding box of the ink that it contains, and render the
     * text at roughly the same size as the bounding box.
     */
    func drawText(recognizedInk: RecognizedInk) {
        let rect = getInkRect(ink: recognizedInk.ink)
        UIGraphicsBeginImageContext(drawnImage.frame.size)
        recognizedImage.image?.draw(
            in: CGRect(
                x: 0, y: 0, width: drawnImage.frame.size.width, height: drawnImage.frame.size.height
            ))
        let ctx: CGContext! = UIGraphicsGetCurrentContext()
        ctx.setBlendMode(CGBlendMode.normal)

        let arbitrarySize: CGFloat = 20
        let font = UIFont.systemFont(ofSize: arbitrarySize)
        let attributes = [
            NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.green,
        ]
        var size = recognizedInk.text!.size(withAttributes: attributes)
        if size.width <= 0 {
            size.width = 1
        }
        if size.height <= 0 {
            size.height = 1
        }
        ctx.translateBy(x: rect.origin.x, y: rect.origin.y)
        ctx.scaleBy(x: ceil(rect.size.width) / size.width, y: ceil(rect.size.height) / size.height)
        recognizedInk.text!.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        ctx.flush()
        recognizedImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

// MARK: - StrokeManagerDelegate -

extension DrawingCanvasViewController: StrokeManagerDelegate {
    /** Displays a status message from the `StrokeManager` to the user. */
    func displayMessage(message _: String) {
        // TODO: Is needed?
//        messageLabel.text = message
    }

    /**
     * Clear temporary ink in progress. This is invoked by the `StrokeManager` when the temporary ink is
     * sent to the recognizer.
     */
    func clearInk() {
        drawnImage.image = nil
    }

    /**
     * Iterate through all the saved ink/recognition results in the `StrokeManager` and render them.
     * This is invoked by the `StrokeManager` when an ink is sent to the recognizer, and when a
     * recognition result is returned.
     */
    func redraw() {
        recognizedImage.image = nil
        let recognizedInks = strokeManager!.recognizedInks
        for recognizedInk in recognizedInks {
            drawInk(ink: recognizedInk.ink)
            if recognizedInk.text != nil {
                drawText(recognizedInk: recognizedInk)
            }
        }
    }
}
