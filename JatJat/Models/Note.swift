//
//  Note.swift
//  JatJat
//
//  Created by alvin joseph valdez on 3/26/20.
//  Copyright © 2020 alvin joseph valdez. All rights reserved.
//

import Foundation
import RealmSwift

class Note: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var writing: String = ""
    @objc dynamic var dateCreated: String = Date().easyDate()
    
    override static func primaryKey() -> String? {
       return "id"
     }
}

extension Date {
    func easyDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
}
