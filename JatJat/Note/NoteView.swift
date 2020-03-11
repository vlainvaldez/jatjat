//
//  NoteView.swift
//  JatJat
//
//  Created by alvin joseph valdez on 3/7/20.
//  Copyright © 2020 alvin joseph valdez. All rights reserved.
//

import UIKit
import Stevia

protocol NoteViewDelegate: class {
    func save()
}

class NoteView: UIView {

    // MARK: - Stored Properties
    private var keyBoardManager: KeyBoardManager!
    
    // MARK: - Views
    var noteArea = UITextView()
    let saveButton = UIButton()
    
    weak var delegate: NoteViewDelegate?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        sv([noteArea.style(noteAreaStyle)])
        
        layout(
            0,
            |noteArea|,
            0
        )
        
        noteArea.bottom(0)
        
        keyBoardManager = KeyBoardManager()
        keyBoardManager.delegate = self
        keyBoardManager.beginObservingKeyboard()
        
        saveButton.style(saveButtonStyle)
        
        saveButton.addTarget(
            self,
            action: #selector(NoteView.save),
            for: .touchUpInside
        )
    }
    
    deinit {
        keyBoardManager?.endObservingKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func saveButtonStyle(_ v: UIButton) {
        v.setTitle("Save", for: .normal)
        v.setTitleColor(
            UIColor(named: "primaryTextColor"),
            for: .normal
        )
    }
    
    func noteAreaStyle(_ v: UITextView) {
        v.backgroundColor = UIColor(named: "primaryBackground")
        v.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.regular)
        v.textColor = UIColor(named: "primaryTextColor")
        v.tintColor = UIColor(named: "primaryTextColor")
    }
    
    @objc private func save() {
        delegate?.save()
    }
}

extension NoteView: KeyBoardManagerDelegate {
    
    func kmDidShow(height: CGFloat) {
        noteArea.bottomConstraint?.constant = -height
        UIView.animate(withDuration: 2) {
            self.layoutIfNeeded()
        }
    }
    
    func kmDidHide() {
        noteArea.bottomConstraint?.constant = 0
        UIView.animate(withDuration: 2) {
            self.layoutIfNeeded()
        }
    }
}
