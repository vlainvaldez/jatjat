//
//  ItemRow.swift
//  JatJat
//
//  Created by alvin joseph valdez on 4/4/20.
//  Copyright © 2020 alvin joseph valdez. All rights reserved.
//

import UIKit
import Stevia

class ItemRow: UITableViewCell {
    
    var label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(named: "primaryBackground")
        selectionStyle = .none
        
        sv(label)
        
        layout(
            0,
            |-20-label-|,
            0
        )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func labelStyle(_ v: UILabel) {
        v.textColor = UIColor(named: "primaryTextColor")
        v.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        v.lineBreakMode = .byTruncatingTail
    }
}

// MARK: - Public APIs
extension ItemRow {
    static var identifier = "ItemRow"
    
    func configure(with note: Note) {
        
        let trimMarkDown = note.writing
            .withoutSpecialCharacters
            .withoutNewLineCharacters
        
        label.text = trimMarkDown
    }
}
