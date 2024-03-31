//
//  LevelProgressBarUIView.swift
//  edu-app
//
//  Created by Filip Čulig on 24.02.2024..
//

import Combine
import UIKit
import SwiftUI

// MARK: - LevelProgressBarUIView -
final class LevelProgressBarUIView: UIView {
    // MARK: - View components -
    
    private lazy var border: UIView = {
        let view = UIView()
        view.layer.borderWidth = 5
        view.layer.borderColor = AppColor.brownBorder.color.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var progressIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.green.uiColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let guidesButton: RoundedUIButton
    private let outlineButton: RoundedUIButton
    private let canvasButton: RoundedUIButton
    
    private lazy var progressBarWidthConstraint: NSLayoutConstraint = {
        NSLayoutConstraint(item: progressIndicator,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .width,
                           multiplier: 1,
                           constant: 0)
    }()
    
    // MARK: - Private properties -
    
    private let viewModel: LevelProgressBarViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers -
    
    init(viewModel: LevelProgressBarViewModel) {
        self.viewModel = viewModel
        self.guidesButton = .init(model: viewModel.guidesButtonModel)
        self.outlineButton = .init(model: viewModel.outlineButtonModel)
        self.canvasButton = .init(model: viewModel.canvasButtonModel)
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {          
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupView()
    }
}

// MARK: - View setup -

private extension LevelProgressBarUIView {
    func setupView() {
        setupBorder()
        setupProgressIndicator()
        setupButtons()
    }
    
    func setupBorder() {
        addSubview(border)
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            border.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            border.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            border.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        border.layer.cornerRadius = (frame.height - 20) / 2
    }
    
    func setupProgressIndicator() {
        border.addSubview(progressIndicator)
        NSLayoutConstraint.activate([
            progressIndicator.leadingAnchor.constraint(equalTo: border.leadingAnchor, constant: 5),
            progressIndicator.topAnchor.constraint(equalTo: border.topAnchor, constant: 5),
            progressIndicator.bottomAnchor.constraint(equalTo: border.bottomAnchor, constant: -5),
            progressIndicator.trailingAnchor.constraint(lessThanOrEqualTo: border.trailingAnchor, constant: -5)
        ])
        
        progressIndicator.layer.cornerRadius = (frame.height - 30) / 2
        
        viewModel.currentProgressPercentage
            .sink { [weak self] in
                guard let self else { return }
                self.progressBarWidthConstraint.constant = CGFloat($0) * (frame.width + 10)
                self.progressBarWidthConstraint.isActive = true
            }
            .store(in: &cancellables)
    }
    
    func setupButtons() {
        [guidesButton.view, outlineButton.view, canvasButton.view].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: topAnchor),
                $0.bottomAnchor.constraint(equalTo: bottomAnchor),
                $0.widthAnchor.constraint(equalToConstant: frame.height)
            ])
        }
        
        let buttonSpacing = (frame.width - (frame.height * 3))/3
        NSLayoutConstraint.activate([
            guidesButton.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            outlineButton.view.leadingAnchor.constraint(equalTo: guidesButton.view.trailingAnchor, constant: buttonSpacing),
            canvasButton.view.leadingAnchor.constraint(equalTo: outlineButton.view.trailingAnchor, constant: buttonSpacing)
        ])
    }
}
