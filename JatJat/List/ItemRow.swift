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
    
    let noteLabel = UILabel()
    let dateLabel = UILabel()
    let customSeparator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(named: "cellBackground")
        selectionStyle = .none
        
        sv(
            noteLabel.style(labelStyle),
            dateLabel.style(dateLabelStyle),
            customSeparator.style(customSeparator)
        )
        
        layout(
            10,
            |-10-noteLabel-|,
            15,
            |-10-dateLabel,
            "",
            |-customSeparator-| ~ 1,
            -5
        )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func labelStyle(_ v: UILabel) {
        v.textColor = UIColor(named: "primaryTextColor")
        v.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        v.lineBreakMode = .byTruncatingTail
    }
    
    private func dateLabelStyle(_ v: UILabel) {
        v.textColor = UIColor.lightGray.withAlphaComponent(0.7)
        v.font = UIFont.systemFont(ofSize: 13.0, weight: .bold)
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
        
        noteLabel.text = trimMarkDown
        if let dateCreated = note.dateCreated {
            dateLabel.text = dateCreated.shortStringDate
        }
    }
}
