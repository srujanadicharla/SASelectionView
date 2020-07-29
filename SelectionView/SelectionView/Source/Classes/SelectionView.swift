//
//  SelectionView.swift
//  SelectionView
//
//  Created by Srujan Simha Adicharla on 7/29/20.
//  Copyright © 2020 Srujan Simha Adicharla. All rights reserved.
//

import UIKit

open class SelectionView: BaseView {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var filterTitleLabel: UILabel!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var barViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var filterViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var filterContainerView: UIView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchCancelButton: UIButton!
    @IBOutlet weak var searchCancelButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewToHeaderViewTopConstraint: NSLayoutConstraint!
    
    var selectedOption: (( _ section : Int, _ row: Int,  _ value: String) -> ())!
    var dismisshandler: (() -> ())?
    var optionsViewYPosition: CGFloat = 150
    
    var filterData = [SectionItem]()
    var searchFilterData = [SectionItem]()
    var showSearchBar: Bool = false
    var emptySearchRowTitle: String?
    var emptyRowHandler: ((_ searchText: String) -> ())?
    
    var constantMultiplier: CGFloat = 0.75
    var searchText: String = ""
    
    var statusBarStyle: UIStatusBarStyle?
    var isSearchActive: Bool {
        get {
            return searchText.isEmpty == false
        }
    }

    public class func show(title: String?, sections: [SectionItem] = [], showSearchBar: Bool = false, emptySearchRowTitle: String? = nil, dismisshandler: (() -> ())? = nil, emptyRowHandler: ((_ searchText: String) -> ())? = nil, selectedOption: @escaping (( _ section : Int, _ row: Int, _ value: String) -> ())) {
        if let keyWindow = UIApplication.shared.keyWindow {
            let nibViews = UINib(nibName: "SelectionView", bundle: Bundle.frameworkBundle).instantiate(withOwner: nil, options: nil)
            if let nibView: SelectionView = nibViews.first as? SelectionView {
                nibView.frame = keyWindow.bounds
                nibView.configure(title: title, sections: sections, showSearchBar: showSearchBar, emptySearchRowTitle: emptySearchRowTitle, dismisshandler: dismisshandler, emptyRowHandler: emptyRowHandler, selectedOption: selectedOption)
                keyWindow.addSubview(nibView)
                nibView.layoutIfNeeded()
            } else {
                fatalError("SelectionView: Nib not instantiated")
            }
        }
    }
    
    public class func hide() {
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                let subviews = keyWindow.subviews
                for subview in subviews {
                    if subview.isKind(of: SelectionView.self) {
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    internal func configure(title: String?, sections: [SectionItem], showSearchBar: Bool, emptySearchRowTitle: String? = nil, dismisshandler: (() -> ())? = nil, emptyRowHandler: ((_ searchText: String) -> ())? = nil, selectedOption: @escaping (( _ section : Int, _ row: Int, _ value: String) -> ()))
    {
        self.filterTitleLabel.text = title?.uppercased()
        self.selectedOption = selectedOption
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 35
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.separatorColor = UIColor.lightGray
        tableView.delegate = self
        tableView.dataSource = self

        tableView.reloadData()
        var totalHeight: CGFloat = 160
        for i in 0..<sections.count {
            sections[i].index = i
            totalHeight += CGFloat(sections[i].options.count * 40)
            if sections[i].title != nil {
                totalHeight += 40
            }
        }
        
        if showSearchBar {
            self.showSearchBar = showSearchBar
        }
        
    //        totalHeight += (showSearchBar ? 160 : 100)
        let totalHeightMultiplier = ((UIScreen.main.bounds.height - totalHeight) / UIScreen.main.bounds.height)
        if totalHeightMultiplier <= 0.25 {
            constantMultiplier = 0.25
            self.showSearchBar = true
        } else if totalHeightMultiplier >= 0.75 {
            constantMultiplier = 0.75
        } else {
            constantMultiplier = totalHeightMultiplier
        }
        
        if self.showSearchBar {
            tableViewToHeaderViewTopConstraint.constant = -40
            searchContainerView.layer.cornerRadius = 20
            searchContainerView.isHidden = false
            searchTextField.addTarget(self, action: #selector(searchTextFieldTapped), for: .touchDown)
            searchTextField.delegate = self
        } else {
            searchContainerView.isHidden = true
            tableViewToHeaderViewTopConstraint.constant = -100
        }

        self.filterData = sections
        self.emptyRowHandler = emptyRowHandler
        self.emptySearchRowTitle = emptySearchRowTitle
        self.dismisshandler = dismisshandler
        
        blurView = insertBlurView(blurStyle: .dark, blurLevel: .low)
        blurView?.animate()
        
        headerContainerView.layer.cornerRadius = 20
        headerContainerView.configureShadow(withColor: .black, opacity: 0.15, radius: 6, offset: CGSize(width: 0, height: 0))
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gesture:)))
        gesture.delegate = self
        headerContainerView.addGestureRecognizer(gesture)
        headerContainerView.isUserInteractionEnabled = true
        
        setFilterHeight(constantMultiplier)
        
        statusBarStyle = UIApplication.shared.statusBarStyle
    }
    
    func setFilterHeight(_ constantMultiplier: CGFloat) {
        self.optionsViewYPosition = (UIScreen.main.bounds.height * constantMultiplier)
        
        if constantMultiplier != 0 {
            barView.isHidden = false
            barViewTopConstraint.constant = 8
            headerContainerView.layer.cornerRadius = 20
            searchTextField.resignFirstResponder()
        } else {
            barView.isHidden = true
            barViewTopConstraint.constant = 40
            headerContainerView.layer.cornerRadius = 0
        }
        
        UIView.animate(withDuration: constantMultiplier == 0 ? 0.3 : 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.filterViewTopConstraint.constant = self.optionsViewYPosition
            self.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.35, delay: constantMultiplier == 0 ? 0.4 : 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.searchCancelButtonTrailingConstraint.constant = constantMultiplier == 0 ? 20: -45
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    override open func blurViewTapped() {
        dismissView()
    }
    
    func dismissView() {
        UIApplication.shared.statusBarStyle = statusBarStyle ?? .lightContent
        blurView?.remove(duration: 0.3)
        filterViewTopConstraint.constant = UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
        }
    }

    @objc func filterContentForSearchText(_ searchText: String, scope: String = "") {
        self.searchText = searchText
        guard !searchText.isEmpty else {
            searchFilterData = filterData
            tableView.reloadData()
            return
        }
        
        searchFilterData.removeAll()
        for i in 0..<filterData.count {
            let options = filterData[i].options.filter({ (opt) -> Bool in
                return opt.lowercased().contains(searchText.lowercased())
            })
            if options.count > 0 {
                searchFilterData.append(SectionItem(title: filterData[i].title, options: options, index: filterData[i].index))
            }
        }
        tableView.reloadData()
    }
    
    @objc func searchTextFieldTapped() {
        UIApplication.shared.statusBarStyle = .default
        setFilterHeight(0)
    }
    
    @IBAction func didClickSearchCancelButton(_ sender: Any) {
        UIApplication.shared.statusBarStyle = statusBarStyle ?? .lightContent
        searchText = ""
        searchTextField.text = nil
        setFilterHeight(constantMultiplier)
        tableView.reloadData()
    }
}

extension SelectionView {
    @objc func wasDragged(gesture: UIPanGestureRecognizer) {
        guard filterViewTopConstraint.constant != 0 else {
            return
        }
        
        let percentThreshold:CGFloat = 0.15
        let translation = gesture.translation(in: self)
        let verticalMovement = translation.y / self.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        if gesture.state == .changed, let _ = gesture.view {
            //            if (view.frame.origin.y + translation.y) >= self.optionsViewYPosition {
            let value = (self.optionsViewYPosition + translation.y)
            //                    self.headerView.frame.origin.y = value
            //            let multiplierConstant:CGFloat = (value < 150 ? 150 : value) * 0.4
            self.filterViewTopConstraint.constant = value
            //            }
        } else if gesture.state == .ended || gesture.state == .cancelled, let view = gesture.view {
            if (view.frame.origin.y + translation.y) > 250 || progress > percentThreshold {
                self.dismissView()
            } else {
                self.filterViewTopConstraint.constant = self.optionsViewYPosition
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1.5, options: .curveEaseOut, animations: {
                    self.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
}

extension SelectionView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        filterContentForSearchText(String(("\(textField.text ?? "")\(string)").dropLast(range.length)))
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        filterContentForSearchText(textField.text ?? "")
        textField.resignFirstResponder()
        return true
    }
}
