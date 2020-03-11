//
//  KeyBoardManagerDelegate.swift
//  JatJat
//
//  Created by alvin joseph valdez on 3/8/20.
//  Copyright © 2020 alvin joseph valdez. All rights reserved.
//

import UIKit

public protocol KeyBoardManagerDelegate: class {
    func kmScrollTo()
    func kmDidShow(height: CGFloat)
    func kmDidHide()
}

extension KeyBoardManagerDelegate {
    public func kmScrollTo() {}
    public func kmDidShow(height: CGFloat) {}
    public func kmDidHide() {}
}
