# SASelectionView

[![license](https://img.shields.io/github/license/DAVFoundation/captain-n3m0.svg?style=flat-square)](https://github.com/DAVFoundation/captain-n3m0/blob/master/LICENSE)
![ios](https://camo.githubusercontent.com/8bf40d4e956c67581e5d6d68ea19480e1baf9763/68747470733a2f2f636f636f61706f642d6261646765732e6865726f6b756170702e636f6d2f702f53656c656374696f6e56696577436f6e74726f6c6c65722f62616467652e706e67) ![v1.9.3](https://camo.githubusercontent.com/5174a2a03f8ef273795d61da8cc0c9910b7cf754/68747470733a2f2f636f636f61706f642d6261646765732e6865726f6b756170702e636f6d2f762f53656c656374696f6e56696577436f6e74726f6c6c65722f62616467652e706e67)


A lightweight single selection view that slides up from bottom of the screen. 
* Easy to use
* Sectioned rows
* Auto adjusting selection view height
* Auto displying searchbar based on the number of items. (you can hide/show searbar manually too)
* Gesture control to drag down to dismiss

<img src="https://github.com/srujanadicharla/SASelectionView/blob/master/Images/saselectionview.gif" width="300" height="649">

*A list showing cities (rows) of respective states (sections)*

## [](https://github.com/srujanadicharla/SASelectionView#requirements) Requirements

SASelectionView works on iOS 9 and higher. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* Foundation
* UIKit

## [](https://github.com/srujanadicharla/SASelectionView#installation) Installation

### CocoaPods 
You can use [CocoaPods](https://guides.cocoapods.org/using/getting-started.html) to install SASelectionView by adding it to your Podfile:

```swift
pod 'SASelectionView'
```

#### Manually
* Download and extraxt zip file.
* Drag and drop Source folder in your project.
* Done!

## [](https://github.com/srujanadicharla/SASelectionView#example) Example
```swift
import UIKit
import SASelectionView

class ViewController: UIViewController {

    @IBOutlet weak var selectedOptionLabel: UILabel!
    
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
        
        SASelectionView.show(title: "Locations", sections: sections, showSearchBar: true, emptySearchRowTitle: "Item not found. Add this ...", emptyRowHandler: { (notFoundText) in
            print("Not found result: \(notFoundText)")
            self.selectedOptionLabel.text = notFoundText
        }) { (section, row, value) in
            self.selectedOptionLabel.text = "\(value), \(sections[section].title ?? "")"
        }
    }
}
```

<img src="https://github.com/srujanadicharla/SASelectionView/blob/master/Images/screenshot1.png" width="300" height="649"><img src="https://github.com/srujanadicharla/SASelectionView/blob/master/Images/screenshot2.png" width="300" height="649">

## [](https://github.com/srujanadicharla/SASelectionView#contribute) Contribute
If you have feature requests or bug reports, please feel free to help out by sending pull requests or create issues.

## [](https://github.com/srujanadicharla/SASelectionView#license) License
This code is distributed under the terms and conditions of the [MIT license](https://github.com/srujanadicharla/SelectionView/blob/master/LICENSE).
