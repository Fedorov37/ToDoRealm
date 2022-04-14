//
//  Task.swift
//  desktopapp
//
//  Created by Администратор on 03.04.2022.
//
import Cocoa
import RealmSwift
import Foundation

class Task: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var important = false
    
    override static func primaryKey() -> String? {
        return "id"
      }
}
