//
//  StrokeManager.swift
//  edu-app
//
//  Created by Filip Culig on 31.03.2022..
//

import Combine
import Foundation
import MLKit
import UIKit

/// Protocol used by the `StrokeManager` to send requests back to the `ViewController` to update the
/// display.
protocol StrokeManagerDelegate {
    /** Clears any temporary ink managed by the caller. */
    func clearInk()
}

/// The `StrokeManager` object is responsible for storing the ink and recognition results, and
/// managing the interaction with the recognizer. It receives the touch points as the user is drawing
/// from the `ViewController` (which takes care of rendering the ink), and stores them into an array
/// of `Stroke`s. When the user taps "recognize", the strokes are collected together into an `Ink`
/// object, and passed to the recognizer. The `StrokeManagerDelegate` protocol is used to inform the
/// `ViewController` when the display needs to be updated.
///
/// The `StrokeManager` provides additional methods to handle other buttons in the UI, including
/// selecting a recognition language, downloading or deleting the recognition model, or clearing the
/// ink.
class StrokeManager {
    /**
     * Array of `RecognizedInk`s that have been sent to the recognizer along with any recognition
     * results.
     */
    var recognizedInks: [RecognizedInk]
    
    /** The view that handles UI stuff. */
    var delegate: StrokeManagerDelegate?
    
    var isDownloadingModel: AnyPublisher<Bool, Never> {
        isDownloadingModelSubject.eraseToAnyPublisher()
    }

    /**
     * Conversion factor between `TimeInterval` and milliseconds, which is the unit used by the
     * recognizer.
     */
    private var kMillisecondsPerTimeInterval = 1000.0

    /** Arrays used to keep the piece of ink that is currently being drawn. */
    private var strokes: [Stroke] = []
    private var points: [StrokePoint] = []

    /** The recognizer that will translate the ink into text. */
    private var recognizer: DigitalInkRecognizer!

    /** Properties to track and manage the selected language and recognition model. */
    private var model: DigitalInkRecognitionModel?
    private var modelManager: ModelManager
    private let isDownloadingModelSubject: PassthroughSubject<Bool, Never> = .init()

    /**
     * Initialization of internal variables as well as creating the model manager and setting up
     * observers of the recognition model downloading status.
     */
    init() {
        modelManager = ModelManager.modelManager()
        recognizedInks = []

        selectLanguage(languageTag: "hr")

        // Add observers for download notifications, and reflect the status back to the user.
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.mlkitModelDownloadDidSucceed, object: nil,
            queue: OperationQueue.main,
            using: {
                [unowned self]
                notification in
                if notification.userInfo![ModelDownloadUserInfoKey.remoteModel.rawValue]
                    as? DigitalInkRecognitionModel == self.model
                {
                    self.isDownloadingModelSubject.send(false)
                    print("Model download succeeded")
                }
            }
        )
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.mlkitModelDownloadDidFail, object: nil,
            queue: OperationQueue.main,
            using: {
                [unowned self]
                notification in
                if notification.userInfo![ModelDownloadUserInfoKey.remoteModel.rawValue]
                    as? DigitalInkRecognitionModel == self.model
                {
                    self.isDownloadingModelSubject.send(false)
                    print("Model download failed")
                }
            }
        )
    }

    /**
     * Check whether the model for the given language tag is downloaded.
     */
    func isLanguageDownloaded(languageTag: String) -> Bool {
        let identifier = DigitalInkRecognitionModelIdentifier(forLanguageTag: languageTag)
        let model = DigitalInkRecognitionModel(modelIdentifier: identifier!)
        return modelManager.isModelDownloaded(model)
    }

    /**
     * Given a language tag, looks up the cooresponding model identifier and initializes the model. Note
     * that this doesn't actually download the model, which is triggered manually by the user for the
     * purposes of this demo app.
     */
    func selectLanguage(languageTag: String) {
        let identifier = DigitalInkRecognitionModelIdentifier(forLanguageTag: languageTag)
        model = DigitalInkRecognitionModel(modelIdentifier: identifier!)
        recognizer = nil
    }

    /**
     * Actually downloads the model. This happens asynchronously with the user being shown status messages
     * when the download completes or fails.
     */
    func downloadModel() {
        if modelManager.isModelDownloaded(model!) {
            print("Model is already downloaded")
            return
        }

        print("Starting model download")
        isDownloadingModelSubject.send(true)

        // The Progress object returned by `downloadModel` currently only takes on the values 0% or 100%
        // so is not very useful. Instead we'll rely on the outcome listeners in the initializer to
        // inform the user if a download succeeds or fails.
        modelManager.download(
            model!,
            conditions: ModelDownloadConditions(
                allowsCellularAccess: true, allowsBackgroundDownloading: true
            )
        )
    }

    /**
     * Actually carries out the recognition. The recognition may happen asynchronously so there's a
     * callback that handles the results when they are ready.
     */
    func recognizeInk(level: Level, letterIndex: Int, onCompletion: @escaping (Level, Int, String?) -> Void) {
        if strokes.isEmpty {
            print("Strokes are empty")
            return
        }
        if !modelManager.isModelDownloaded(model!) {
            print("Model is not downloaded")
            return
        }
        if recognizer == nil {
            let options = DigitalInkRecognizerOptions(model: model!)
            recognizer = DigitalInkRecognizer.digitalInkRecognizer(options: options)
        }

        // Turn the list of strokes into an `Ink`, and add this ink to the `recognizedInks` array.
        let ink = Ink(strokes: strokes)
        let recognizedInk = RecognizedInk(ink: ink)
        recognizedInks.append(recognizedInk)

        // Clear the currently being drawn ink, and display the ink from `recognizedInks` (which results
        // in it changing color).
//        delegate.clearInk()
//        strokes = []

        // Start the recognizer. Callback function will store the recognized text and tell the
        // `ViewController` to redraw the screen to show it.
        recognizer.recognize(
            ink: ink,
            completion: { [recognizedInk] (result: DigitalInkRecognitionResult?, _: Error?) in
                var recognitionResult: String?
                if let result = result, let candidate = result.candidates.first {
                    recognizedInk.text = candidate.text
                    var message = "Recognized: \(candidate.text)"
                    if candidate.score != nil {
                        message += " score \(candidate.score!.floatValue)"
                    }

                    recognitionResult = candidate.text
//                    self.delegate?.displayMessage(message: message)
                } else {
                    recognizedInk.text = "error"
//                    self.delegate?.displayMessage(message: "Recognition error " + String(describing: error))
                }

                onCompletion(level, letterIndex, recognitionResult)
            }
        )
    }

    /** Clear out all the ink and other state. */
    func clear() {
        recognizedInks = []
        strokes = []
        points = []
    }

    /** Begins a new stroke when the user touches the screen. */
    func startStrokeAtPoint(point: CGPoint, t: TimeInterval) {
        points = [
            StrokePoint(
                x: Float(point.x), y: Float(point.y), t: Int(t * kMillisecondsPerTimeInterval)
            ),
        ]
    }

    /** Adds an additional point to the stroke when the user moves their finger. */
    func continueStrokeAtPoint(point: CGPoint, t: TimeInterval) {
        points.append(
            StrokePoint(
                x: Float(point.x), y: Float(point.y),
                t: Int(t * kMillisecondsPerTimeInterval)
            ))
    }

    /** Completes a stroke when the user lifts their finger. */
    func endStrokeAtPoint(point: CGPoint, t: TimeInterval) {
        points.append(
            StrokePoint(
                x: Float(point.x), y: Float(point.y),
                t: Int(t * kMillisecondsPerTimeInterval)
            ))
        // Create an array of strokes if it doesn't exist already, and add this stroke to it.
        strokes.append(Stroke(points: points))
        points = []
    }
}
