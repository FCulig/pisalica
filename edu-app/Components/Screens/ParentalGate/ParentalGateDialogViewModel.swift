//
//  ParentalGateDialogViewModel.swift
//  edu-app
//
//  Created by Filip Culig on 28.05.2023..
//

import Combine

// MARK: - ParentalGateDialogViewModel -
extension ParentalGateDialogView {
    final class ViewModel: ObservableObject {
        // MARK: - Public properties -
        
        @Published var isShowingDialog = true
        @Published var isShowingErrorDialog = false
        @Published var solution: Int? = nil
        @Published var firstNumber = 0
        @Published var secondNumber = 0
        
        // MARK: - Initializer -
        
        init() {
            generateRandomNumbers()
        }
    }
}

// MARK: - Public methods -

extension ParentalGateDialogView.ViewModel {
    func didTapOkQuestionDialog() {
        if firstNumber + secondNumber == solution {
            isShowingDialog = false
        } else {
            isShowingDialog = true
            isShowingErrorDialog = true
            generateRandomNumbers()
        }
        
        solution = nil
    }
    
    func didTapOkErrorDialog() {
        isShowingDialog = true
        isShowingErrorDialog = false
    }
}

// MARK: - Private methods -

private extension ParentalGateDialogView.ViewModel {
    func generateRandomNumbers() {
        firstNumber = Int.random(in: 1..<100)
        secondNumber = Int.random(in: 1..<100)
    }
}
