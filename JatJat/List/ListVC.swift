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
    var disposeBag = DisposeBag()
    var notesObservable: BehaviorRelay<[Note]> = BehaviorRelay<[Note]>(value: [Note]())
    
    private var dataSource: ItemDataSource!
    
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

        getTableView().register(ItemRow.self, forCellReuseIdentifier: ItemRow.identifier)
        getTableView().delegate = self
        
        setUpDataSource()
        bindNotes()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        let realmNotes = realm.objects(Note.self)
        Observable.array(from: realmNotes)
            .bind(to: self.notesObservable)
            .disposed(by: disposeBag)

        notesObservable.subscribe(onNext: { [weak self] notes in
            self?.updateTableView(animated: false, dataProvider: notes)
        }).disposed(by: disposeBag)
    }
    
    @objc private func addNote() {
        let vc = NoteVC()
        self.push(vc: vc)
    }
    
    func setUpDataSource() {
        dataSource = ItemDataSource(
            tableView: getTableView(),
            cellProvider: { (tableView, indexPath, note) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(
                withIdentifier:
                ItemRow.identifier, for: indexPath) as! ItemRow
            cell.configure(with: note)
            return cell
        })
    }
    
    func updateTableView(animated: Bool, dataProvider: [Note]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Note>()
        snapshot.appendSections([.main])
      snapshot.appendItems(dataProvider, toSection: .main)
      dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    private func delete(note: Note) {
        try! realm.write {
            realm.delete(note)
        }
    }
}

extension ListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(
        style: .destructive,
        title: "Delete") {  [weak self] (contextualAction, view, boolValue) in
        
            guard let self = self else { return }
            let model = self.notesObservable.value[indexPath.item]
                
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([model])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            self.delete(note: model)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        let note = notesObservable.value[indexPath.item]
        let vc = NoteVC(model: note)
        push(vc: vc)
    }
}

extension Results {
    func toArray() -> [Element] {
        return compactMap { $0 }
    }
}

enum Section {
  case main
}

class ItemDataSource: UITableViewDiffableDataSource<Section, Note>{
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
