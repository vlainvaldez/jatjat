//
//  NoteVC.swift
//  JatJat
//
//  Created by alvin joseph valdez on 3/7/20.
//  Copyright © 2020 alvin joseph valdez. All rights reserved.
//

import UIKit
import RealmSwift
import Down

class NoteVC: UIViewController {
    
    
    let realm = try! Realm()
    
    // MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    override func loadView() {
        super.loadView()
        let noteView = NoteView()
        noteView.delegate = self
        self.view = noteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Note"
        edgesForExtendedLayout = []
        
        setUpNavigation()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        inkTest()
    }
    
    
}

// MARK: - Helper functions
extension NoteVC {
    
    func getView() -> NoteView {
        return self.view as! NoteView
    }
    
    func setUpNavigation() {
        let saveButton = getView().saveButton
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItems = [saveBarButtonItem]        
    }
    
    func inkTest() {
        let markDown: String = "``` let saveButton = getView().saveButton ```"
        let down = Down(markdownString: markDown)
        let attributedString = try? down.toAttributedString()
        getView().noteArea.attributedText = attributedString
    }
}

extension NoteVC: NoteViewDelegate {
    func save() {
        guard
            let writing = getView().noteArea.text
        else { return }
        
        let note = Note()
        note.writing = writing

        try! realm.write {
            realm.add(note)
        }
    }
}
