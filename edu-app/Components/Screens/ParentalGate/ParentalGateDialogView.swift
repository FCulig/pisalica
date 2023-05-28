//
//  PretnalGateDialogView.swift
//  edu-app
//
//  Created by Filip Culig on 28.05.2023..
//

import SwiftUI

// MARK: - ParentalGateDialogView -
struct ParentalGateDialogView<Content: View> : View {
    private let content: Content
    @ObservedObject private var viewModel: ViewModel
    
    // MARK: - Initializer -
    
    init(viewModel: ViewModel = .init(), @ViewBuilder content: () -> Content) {
        self.viewModel = viewModel
        self.content = content()
    }
    
    // MARK: - Body -

    var body: some View {
        content
            .alert("Roditeljska kontrola", isPresented: $viewModel.isShowingDialog) {
                TextField("\(viewModel.firstNumber) + \(viewModel.secondNumber)", value: $viewModel.solution, format: .number)
                    .keyboardType(.numberPad)
                SwiftUI.Button("OK", action: viewModel.didTapOkQuestionDialog)
            } message: {
                Text("Koliko je \(viewModel.firstNumber) + \(viewModel.secondNumber)?")
            }
            .alert("Netočno", isPresented: $viewModel.isShowingErrorDialog) {
                SwiftUI.Button("OK", action: viewModel.didTapOkErrorDialog)
            } message: {
                Text("Pogrešan odgovor, pokušajte ponovo!")
            }
    }
}

struct ParentalGateDialogView_Previews: PreviewProvider {
    static var previews: some View {
        ParentalGateDialogView {
            Text("Parental gate")
        }
    }
}
