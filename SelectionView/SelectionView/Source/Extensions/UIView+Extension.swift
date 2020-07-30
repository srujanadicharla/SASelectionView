//
//  UIView+Extension.swift
//  SelectionView
//
//  Created by Srujan Simha Adicharla on 7/29/20.
//  Copyright © 2020 Srujan Simha Adicharla. All rights reserved.
//

import UIKit

extension UIView {
    func insertBlurView() -> UIView {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.black.withAlphaComponent(0.54)
        view.frame = self.bounds
        self.insertSubview(view, at: 0)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }
    
    func animate(delay: CGFloat = 0.0) {
        self.alpha = 0
        UIView.animate(withDuration: 0.35, delay: TimeInterval(delay), options: .curveEaseInOut, animations: {
            self.alpha = 1
        }, completion: nil)
    }
    
    /// removed blur view thats already to view
    func remove(duration: TimeInterval = 0.5, delay: CGFloat = 0.0) {
        UIView.animate(withDuration: duration, delay: TimeInterval(delay), options: .curveEaseInOut, animations: {
            self.alpha = 0
        }, completion: { (_) in
            self.removeFromSuperview()
        })
    }
    
    func configureShadow(withColor color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize = .zero) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    func removeShadow() {
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
    }
}
