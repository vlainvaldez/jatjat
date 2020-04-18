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
    @objc dynamic var dateCreated: Date?
    
    override static func primaryKey() -> String? {
       return "id"
     }
}

extension Date {
    var shortDate: Date? {
        let format = DateFormatter()
        format.timeStyle = .none
        format.dateStyle = .medium
        format.timeZone = TimeZone(identifier: "UTC")
        let formattedDate = format.string(from: self)
        return format.date(from: formattedDate)
    }
    
    var shortStringDate: String? {
        let format = DateFormatter()
        format.timeStyle = .none
        format.dateStyle = .medium
        format.timeZone = TimeZone(identifier: "UTC")
        let formattedDate = format.string(from: self)
        return formattedDate
    }
}
