//
//  View+MeasureSize.swift
//  edu-app
//
//  Created by Filip Culig on 31.05.2022..
//

import SwiftUI

// MARK: - View + Blink -

struct BlinkingModifier: ViewModifier {
    let state: Binding<Bool>
    let repeatCount: Int
    let duration: Double

    // internal wrapper is needed because there is no didFinish of Animation now
    private var blinking: Binding<Bool> {
        Binding<Bool>(get: {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) {
                self.state.wrappedValue = false
            }
            return self.state.wrappedValue
        }, set: {
            self.state.wrappedValue = $0
        })
    }

    func body(content: Content) -> some View {
        content
            .opacity(blinking.wrappedValue ? 0 : 1)
            .animation(Animation.linear(duration: duration).repeatCount(repeatCount))
    }
}

extension View {
    func blink(on state: Binding<Bool>, repeatCount: Int = 1, duration: Double = 0.5) -> some View {
        modifier(BlinkingModifier(state: state, repeatCount: repeatCount, duration: duration))
    }
}
