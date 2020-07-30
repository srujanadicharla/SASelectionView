//
//  Bundle+Extension.swift
//  SelectionView
//
//  Created by Srujan Simha Adicharla on 7/29/20.
//  Copyright © 2020 Srujan Simha Adicharla. All rights reserved.
//

import Foundation

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
