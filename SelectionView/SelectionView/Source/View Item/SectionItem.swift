//
//  SectionItem.swift
//  SelectionView
//
//  Created by Srujan Simha Adicharla on 7/29/20.
//  Copyright © 2020 Srujan Simha Adicharla. All rights reserved.
//

import Foundation

public class SectionItem {
    public var title: String?
    public var options: [String]
    public var disabledIndices: [Int:[Int]]
    
    internal var index: Int
    
    public init(title: String?, options: [String], index: Int = 0, disabledIndices: [Int:[Int]] = [:]) {
        self.title = title
        self.options = options
        self.index = index
        self.disabledIndices = disabledIndices
    }
}
