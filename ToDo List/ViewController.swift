//
//  ViewController.swift
//  ToDo List
//
//  Created by Jason Cox on 6/1/24.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var importantCheckbox: NSButton!
    
    var toDoItems : [ToDoItem] = []
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getToDoItems()
    }

    // Consider deleting vs not deleting the code section below
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func getToDoItems() {
        // Get the toDoItems from coredata
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            do {
                // set them to the class property
                toDoItems = try context.fetch(ToDoItem.fetchRequest())
                print(toDoItems.count)
            } catch {}
        }
        // Update the table
        tableView.reloadData()
    }
    
    
    @IBAction func addClicked(_ sender: Any) {
        if textField.stringValue != "" {
            
            // get the managedObjectContext from the AppDelegate
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                
                // make a toDoItem from CoreData
                let toDoItem = ToDoItem(context: context)
                
                // set the properties for the toDoItem
                toDoItem.name = textField.stringValue
                if importantCheckbox.state.rawValue == 0 {
                    // Not Important
                    toDoItem.important = false
                } else {
                    // Important
                    toDoItem.important = true
                }
                
                (NSApplication.shared.delegate as? AppDelegate)?.save()
                
                textField.stringValue = ""
                importantCheckbox.state = NSControl.StateValue(rawValue: 0)
                
                getToDoItems()
                    
            }
        }
    }
    
    // MARK: - TableView Stuff
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let toDoItem = toDoItems[row]

        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "importantColumn")  {
            // Important column
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "importantColumn"), owner: self) as? NSTableCellView {
                
                if toDoItem.important {
                    
                    cell.textField?.stringValue = "🔥"
                } else {
                    
                    cell.textField?.stringValue = ""
                    
                }
                
                return cell
            }
            
        } else {
            // TODO Name
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "todoColumn"), owner: self) as? NSTableCellView {
                
                cell.textField?.stringValue = toDoItem.name!
                
                return cell
            }
            
        }
        
        
        
        
        return nil
    }
    
}

