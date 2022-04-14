//
//  ViewController.swift
//  desktopapp
//
//  Created by Администратор on 23.03.2022.
//

import Cocoa
import RealmSwift

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    var realm: Realm!
    var taskList: Results<Task>!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var checkboxButton: NSButton!
    @IBOutlet weak var deleteButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.realm = self.getDB()
        self.taskList = realm.objects(Task.self)
        tableView.reloadData()
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    override func viewWillAppear() {
        self.realm = self.getDB()
        self.taskList = realm.objects(Task.self)
    }
    
    private func getDB() -> Realm {
           
            let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
            let dbPath = docPath.appending("/defaultDB.realm")
            let defaultRealm = try! Realm(fileURL: URL.init(string: dbPath)!)

            return defaultRealm
        }


    @IBAction func addButton(_ sender: NSButton) {
        if textField.stringValue != "" {
            let task = Task()
            task.name = textField.stringValue
            if checkboxButton.state == .off {
                task.important = false
            } else {
                task.important = true
            }
            
            try! realm.write({ () -> Void in
                realm.add(task)
            })

            textField.stringValue = ""
            checkboxButton.state = .off
            
            tableView.reloadData()
        }
    }
    
    @IBAction func deleteButton(_ sender: NSButton) {
        let task = taskList[tableView.selectedRow]
        try! realm.write({ () -> Void in
            realm.delete(task)
        })
        tableView.reloadData()
        deleteButton.isHidden = true
    }
    
    @IBAction func editButton(_ sender: NSButton) {
        let task = taskList[tableView.selectedRow]
        try! realm.write({ () -> Void in
            task.name = textField.stringValue
            if checkboxButton.state == .off {
                task.important = false
            } else {
                task.important = true
            }
        })
        tableView.reloadData()
        deleteButton.isHidden = true
    }
    
    // MARK: - TableView
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard taskList != nil else { return 0}
        return taskList.count
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let taskList = taskList[row]
         
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "importantColumn") {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "importantCell"), owner: self) as? NSTableCellView {

                if taskList.important {
                    cell.textField?.stringValue = "❗️"
                } else {
                    cell.textField?.stringValue = ""
                }
                return cell
            }
        } else {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "todoitems"), owner: self) as? NSTableCellView {
                cell.textField?.stringValue = taskList.name
                return cell
            }
        }
        return nil
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteButton.isHidden = false
    }
}

