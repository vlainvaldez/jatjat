//
//  ListVC.swift
//  JatJat
//
//  Created by alvin joseph valdez on 4/3/20.
//  Copyright © 2020 alvin joseph valdez. All rights reserved.
//

import UIKit
import RealmSwift
import RxDataSources
import RxSwift
import RxRealm
import RxCocoa

class ListVC: UIViewController {
    
    let realm = try! Realm()
    let disposeBag = DisposeBag()
    var notesObservable: BehaviorRelay<[Note]> = BehaviorRelay<[Note]>(value: [Note]())
    
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
        let listView = ListView()
        self.view = listView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        
        setNavigationBar()
        push(vc: NoteVC())
        
        bindNotes()
        bindTableViewDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: " ",
            style: .plain,
            target: nil,
            action: nil
        )
    }
    
    func getView() -> ListView {
        return self.view as! ListView
    }
    
    func getTableView() -> UITableView {
        return getView().tableView
    }
}

// MARK: - Helper Methods
extension ListVC {
    
    private func setNavigationBar() {
        navigationItem.title = "Scratch Pad"
        
        let view: UIBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(ListVC.addNote)
        )
        
        navigationItem.rightBarButtonItems = [view]
    }
    
    private func push(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func bindNotes() {
        let realmNotes = self.realm.objects(Note.self)
        
        Observable.array(from: realmNotes)
            .bind(to: self.notesObservable)
            .disposed(by: self.disposeBag)
    }
    
    private func bindTableViewDataSource() {
        notesObservable.bind(
            to: getTableView().rx.items(cellIdentifier: ItemRow.identifier)
        ) { index, model, cell in
            guard let cell = cell as? ItemRow else { return }
            cell.configure(with: model)
        }.disposed(by: self.disposeBag)
        
        getTableView().rx.setDelegate(self).disposed(by: self.disposeBag)
        
        getTableView().rx.modelSelected(Note.self).subscribe(onNext: { [weak self] note in
            let vc = NoteVC(model: note)
            self?.push(vc: vc)
        }).disposed(by: self.disposeBag)
    }
    
    @objc private func addNote() {
        let vc = NoteVC()
        self.push(vc: vc)
    }
}

extension ListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension Results {
    func toArray() -> [Element] {
        return compactMap { $0 }
    }
}
