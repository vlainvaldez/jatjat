//
//  ListVC.swift
//  JatJat
//
//  Created by alvin joseph valdez on 4/3/20.
//  Copyright © 2020 alvin joseph valdez. All rights reserved.
//

import UIKit

class ListVC: UIViewController {
    
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
        
        
        setNavigationBar()
        push(vc: NoteVC())
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
}
