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
    var customSeparator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(named: "cellBackground")
        selectionStyle = .none
        
        sv(label, customSeparator.style(customSeparator))
        
        layout(
            0,
            |-20-label-|,
            0,
            |-customSeparator-| ~ 1,
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
    
    private func customSeparator(_ v: UIView) {
        v.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
    }
}

// MARK: - Public APIs
extension ItemRow {
    static var identifier = String(describing: ItemRow.self)
    
    func configure(with note: Note) {
        
        let trimMarkDown = note.writing
            .withoutSpecialCharacters
            .withoutNewLineCharacters
        
        label.text = trimMarkDown
    }
}
