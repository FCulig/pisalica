//
//  LottieView.swift
//  edu-app
//
//  Created by Filip Čulig on 11.02.2024..
//

import Combine
import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    let viewModel: LottieViewModel
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
    
    func makeUIView(context: Context) -> UIView {
        let animationView = LottieAnimationView(name: viewModel.animationFileName)
        
        let view = UIView(frame: .zero)
        view.addSubview(animationView)
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        animationView.loopMode = viewModel.loopMode
        
        animationView.play()
//        animationView.isHidden = true
        
//        viewModel.playAnimation = {
//            animationView.isHidden = false
//            animationView.play() { completed in
//                guard completed else { return }
//                animationView.isHidden = true
//            }
//        }
        
        return view
    }
}
