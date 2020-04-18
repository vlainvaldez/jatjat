//
//  NoteVC.swift
//  JatJat
//
//  Created by alvin joseph valdez on 3/7/20.
//  Copyright © 2020 alvin joseph valdez. All rights reserved.
//

import UIKit
import RealmSwift
//import Down
import HEXColor
import Ink

class NoteVC: UIViewController {

    let realm = try! Realm()
    var model: Note?
    
    // MARK: - Initializer
    init(model: Note? = nil) {
        self.model = model
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
        
        setEditBarButtonItem()
        
        if let note = self.model {
            render(note: note)
        } else {
            checkIfNoteExist()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        navigationController?.navigationBar.tintColor = UIColor(named: "primaryTextColor")        
    }
    
}

// MARK: - Helper functions
extension NoteVC {
    
    func getView() -> NoteView {
        return self.view as! NoteView
    }
    
    private func setEditBarButtonItem() {
        let editButton = getView().editButton
        let editBarButtonItem = UIBarButtonItem(
            customView: editButton
        )
        navigationItem.rightBarButtonItems = [editBarButtonItem]
    }
    
    private func setSaveBarButtonItem() {
        let saveButton = getView().saveButton
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.setRightBarButton(saveBarButtonItem, animated: true)
    }
    
    private func render(note: Note) {
        renderMarkdown(note: note.writing)
        self.model = note
    }
    
    private func checkIfNoteExist() {
        guard let note = getNoteOnSameDay() else { return }
        renderMarkdown(note: note.writing)
        self.model = note
    }
    
    private func renderMarkdown(note: String) {
        
        let data = MarkDownManager.render(note)
        
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            getView().noteArea.attributedText = attributedString
        }
    }
    
    private func getNoteOnSameDay() -> Note? {
        let noteOnThisDay = realm.objects(Note.self)
            .filter("dateCreated == %@", Date().shortDate!).first
        return noteOnThisDay
    }
}

extension NoteVC: NoteViewDelegate {
    
    func edit() {
        getView().noteArea.isEditable = true
        
        if let note = model {
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor(named: "primaryTextColor"),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.regular)
            ]
            
            let attributedString = NSAttributedString(string: note.writing, attributes: attributes as [NSAttributedString.Key : Any])
            getView().noteArea.attributedText = attributedString
        }
        
        setSaveBarButtonItem()
    }
    
    func save() {
        guard
            let writing = getView().noteArea.text
        else { return }
        
        if let note = model {
            try! realm.write {
                note.writing = writing
            }
        } else {
            let noteOnThisDay = getNoteOnSameDay()
            
            try! realm.write {
                if let existingNote = noteOnThisDay {
                    existingNote.writing = writing
                } else {
                    let note = Note()
                    note.writing = writing
                    note.dateCreated = Date().shortDate!
                    realm.add(note)
                }
            }
        }
        
        setEditBarButtonItem()
        getView().noteArea.isEditable = false
        renderMarkdown(note: writing)
    }
}
