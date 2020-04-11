//
//  String+Extensions.swift
//  JatJat
//
//  Created by alvin joseph valdez on 4/11/20.
//  Copyright © 2020 alvin joseph valdez. All rights reserved.
//

import Foundation

extension String {
    var withoutSpecialCharacters: String {
        return self.components(separatedBy: CharacterSet.symbols).joined(separator: "")
    }
    var withoutNewLineCharacters: String {
        return self.components(separatedBy: CharacterSet.newlines).joined(separator: " ")
    }
}
