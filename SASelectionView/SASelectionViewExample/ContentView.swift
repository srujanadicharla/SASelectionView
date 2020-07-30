//
//  ContentView.swift
//  SASelectionViewExample
//
//  Created by Srujan Simha Adicharla on 7/29/20.
//  Copyright © 2020 Srujan Simha Adicharla. All rights reserved.
//

import SwiftUI
import SASelectionView

struct ContentView: View {
    
    @State private var selectedText = ""
    
    var body: some View {
        VStack {
            Button(action: {
                self.showSelectionView()
            }) {
                Text("Show List")
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
            
            Text(selectedText)
        }
        
    }
    
    func showSelectionView() {
        var sections = [SectionItem]()
        sections.append(SectionItem(title: "Texas", options: ["Dallas", "Houston", "Austin", "San Antonio"]))
        sections.append(SectionItem(title: "California", options: ["Los Angeles", "San Francisco", "Sacramento", "San Diago"]))
        sections.append(SectionItem(title: "New York", options: ["New York City", "Albany", "Buffalo"]))
        sections.append(SectionItem(title: "Florida", options: ["Miami", "Orlando", "Jacksonville", "Key West"], disabledIndices: [3:[1,3]]))

        SASelectionView.show(title: "Locations", sections: sections, showSearchBar: true, emptySearchRowTitle: "Item not found. Add this ...", emptyRowHandler: { (notFoundText) in
            print("Not found result: \(notFoundText)")
            self.selectedText = notFoundText
        }) { (section, row, value) in
            self.selectedText = "\(value), \(sections[section].title ?? "")"
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
