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
        backgroundColor = UIColor(named: "dark")
        
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
    }
}

struct Text {
    static func render(_ text: String) -> Data{
        let styleSheet = """
            * {font-family: Helvetica }
            pre code {
                font-size: 16px;
                color: \(UIColor(named: "codeColor")!.hexString());
                background-color: \(UIColor(named: "dark")!.hexString());
                font-family: Menlo;
                margin: 10px;
                display: block;
            }
        
            p code {
                font-size: 16px;
                color: \(UIColor(named: "codeColor")!.hexString());
                background-color: \(UIColor(named: "dark")!.hexString());
                font-family: Menlo;
                margin: 10px;
                display: block;
            }
            
            h1, h2, h3,
            h4, h5, h6 {
                color: \(UIColor(named: "primaryTextColor")!.hexString());
            }
        
            ul, li {
                color: \(UIColor(named: "primaryTextColor")!.hexString());
                font-size: 16px;
            }
        
            p {
                font-size: 15px;
                color: \(UIColor(named: "primaryTextColor")!.hexString());
                display: block;
            }
        """
        let paragraphsModifier = Modifier(target: .paragraphs) { html, markdown in
            return "<br> " + html
        }
        
        let codeModifier = Modifier(target: .codeBlocks) { html, markdown in
            return html + "<br>"
        }
        
        var parser = MarkdownParser()
        parser.addModifier(paragraphsModifier)
        parser.addModifier(codeModifier)
        let result = parser.html(from: text)
        let data = Data("<style> \(styleSheet) </style> \( result)".utf8)
    
        return data
    }
}
