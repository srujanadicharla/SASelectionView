//
//  RegisterCell+Extensions.swift
//  SASelectionView
//
//  Created by Srujan Simha Adicharla on 7/29/20.
//  Copyright © 2020 Srujan Simha Adicharla. All rights reserved.
//

import UIKit

private struct AssociatedObjectKey {
    static var registeredCells = "registeredCells"
}

// MARK:- Reuse Identifier helpers
public protocol ReusableView: class {
    static var reuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

// MARK:- Nib name helpers
public protocol NibLoadableView: class {
    static var nibName: String { get }
}

public extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView { }
extension UITableViewCell: NibLoadableView { }

//MARK:- TableView Cell and HeaderFooterView, registration and deque helpers
public extension UITableView {
    private var registeredCells: Set<String> {
        get {
            if objc_getAssociatedObject(self, &AssociatedObjectKey.registeredCells) as? Set<String> == nil {
                self.registeredCells = Set<String>()
            }
            return objc_getAssociatedObject(self, &AssociatedObjectKey.registeredCells) as! Set<String>
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedObjectKey.registeredCells, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func register<T: UITableViewCell>(reusableCell _: T.Type) {
        let bundle = Bundle(for: T.self)
        if bundle.path(forResource: T.nibName, ofType: "nib") != nil {
            self.register(UINib(nibName: T.nibName, bundle: bundle), forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        let identifier: String = T.reuseIdentifier
        if self.registeredCells.contains(identifier) == false {
            self.registeredCells.insert(identifier)
            self.register(reusableCell: T.self)
        }
        
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(identifier)")
        }
        
        return cell
    }
}
