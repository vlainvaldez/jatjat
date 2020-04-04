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

class ListVC: UIViewController {
    
    let realm = try! Realm()
    let disposeBag = DisposeBag()
    var notes = [Note]()
    
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
        
        getNotes()
        setTableViewDataSource()
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
}

// MARK: - Helper Methods
extension ListVC {
    
    private func setNavigationBar() {
        navigationItem.title = "Scratch Pad"
    }
    
    private func push(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getNotes() {
        notes = self.realm.objects(Note.self).toArray()
    }
    
    private func setTableViewDataSource() {
        let data = Observable<[Note]>.just(notes)
        let tableView = getView().tableView
        
        data.bind(
            to: tableView.rx.items(cellIdentifier: ItemRow.identifier)
        ) { index, model, cell in
            guard let cell = cell as? ItemRow else { return }
            cell.configure(with: model)
        }.disposed(by: self.disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        
        tableView.rx.modelSelected(Note.self).subscribe(onNext: { note in
            
        }).disposed(by: self.disposeBag)
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
