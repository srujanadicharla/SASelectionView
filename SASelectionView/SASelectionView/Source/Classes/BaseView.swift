//
//  BaseView.swift
//  SASelectionView
//
//  Created by Srujan Simha Adicharla on 7/29/20.
//  Copyright © 2020 Srujan Simha Adicharla. All rights reserved.
//

import UIKit

extension BaseView: NibLoadableView { }

open class BaseView: UIView, UIGestureRecognizerDelegate {
    
    
    public var blurView: UIView? = nil {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(blurViewTapped))
            gesture.delegate = self
            blurView?.addGestureRecognizer(gesture)
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }

    open class func loadView<T: UIView>() -> T? where T: NibLoadableView {
        let views = UINib(nibName: self.nibName, bundle: Bundle(for: T.classForCoder())).instantiate(withOwner: nil, options: nil)
        if !views.isEmpty, let view = views.first as? T {
            return view
        }
        
        return nil
    }
    
    @objc open func blurViewTapped() {
        
    }
}
