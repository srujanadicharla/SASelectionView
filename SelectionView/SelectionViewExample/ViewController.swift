//
//  ViewController.swift
//  SelectionViewExample
//
//  Created by Srujan Simha Adicharla on 7/29/20.
//  Copyright © 2020 Srujan Simha Adicharla. All rights reserved.
//

import UIKit
import SelectionView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapButton(_ sender: Any) {
        var sections = [SectionItem]()
        sections.append(SectionItem(title: "Texas", options: ["Dallas", "Houston", "Austin", "San Antonio"]))
        sections.append(SectionItem(title: "California", options: ["Los Angeles", "San Francisco", "Sacramento", "San Diago"]))
        sections.append(SectionItem(title: "New York", options: ["New York City", "Albany", "Buffalo"]))
        sections.append(SectionItem(title: "Florida", options: ["Miami", "Orlando", "Jacksonville", "Key West"], disabledIndices: [3:[1,3]]))
        
        SelectionView.show(title: "Locations", sections: sections, showSearchBar: true, emptySearchRowTitle: "Item not found", emptyRowHandler: { (notFoundText) in
            print("Not found result: \(notFoundText)")
        }) { (section, row, value) in
            print("Selected: \(value), \(sections[section].title ?? "")")
        }
    }
    
}

