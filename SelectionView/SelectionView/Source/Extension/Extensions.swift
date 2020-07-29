//
//  UIView+Extension.swift
//  SelectionView
//
//  Created by Srujan Simha Adicharla on 7/29/20.
//  Copyright © 2020 Srujan Simha Adicharla. All rights reserved.
//

import UIKit


enum BackgroundBlurLevel: CGFloat {
    case low = 0.24
    case medium = 0.54
    case high = 0.84
}

extension UIView {
    func insertBlurView(blurStyle: UIBlurEffect.Style = .dark, blurLevel: BackgroundBlurLevel = .medium) -> UIView {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = blurStyle == .dark ? UIColor.black.withAlphaComponent(blurLevel.rawValue) : UIColor.white.withAlphaComponent(blurLevel.rawValue)
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

extension Bundle {
    class public func getBundle(classIs : AnyClass) -> Bundle{
        return Bundle(for: classIs)
    }
    
    open class var frameworkBundle: Bundle {
        get {
            return Bundle(identifier: "com.srujansimha.SelectionView") ?? Bundle.main
        }
    }
}

