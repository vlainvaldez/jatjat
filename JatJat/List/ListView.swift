//
//  ListView.swift
//  JatJat
//
//  Created by alvin joseph valdez on 4/3/20.
//  Copyright © 2020 alvin joseph valdez. All rights reserved.
//

import UIKit
import Stevia
import Ink

class ListView: UIView {
    
    let tableView = UITableView()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "primaryBackground")
        
        sv(tableView.style(tableViewStyle))
        
        layout(
            0,
            |tableView|,
            0
        )
        
        tableView.register(ItemRow.self, forCellReuseIdentifier: ItemRow.identifier)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableViewStyle(_ v: UITableView) {
        v.backgroundColor = .clear
        v.separatorStyle = .none
    }
}
