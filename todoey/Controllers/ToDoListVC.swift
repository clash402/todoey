//
//  ViewController.swift
//  todoey
//
//  Created by Josh Courtney on 5/4/21.
//

import UIKit
import RealmSwift

class ToDoListVC: SwipeTableVC {
    
    let realm = try! Realm()
    var items: Results<Item>?
    var category: Category? {
        didSet {
            loadItems()
        }
    }

    @IBAction func addBtnTapped(_ sender: UIBarButtonItem) {
        presentAddItemAlert { title in
            self.saveItem(with: title)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Alerts
    
    func presentAddItemAlert(_ handler: @escaping (_ itemTitle: String)->()) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            guard let text = textField.text else { return }
            
            if text != "" {
                handler(text)
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data
    
    func saveItem(with title: String) {
        guard let currentCategory = category else { return }
        
        do {
            try realm.write {
                let item = Item()
                
                item.dateCreated = Date()
                item.title = title
                
                currentCategory.items.append(item)
            }
        } catch {
            print(error)
        }
    }
    
    func loadItems() {
        items = category?.items.sorted(byKeyPath: "dateCreated", ascending: true)
    }
    
    func updateItemCompletionStatus(at index: Int) {
        guard let item = items?[index] else { return }
        
        do {
            try realm.write {
                item.isComplete = !item.isComplete
            }
        } catch {
            print(error)
        }
    }
    
    func deleteItem(at index: Int) {
        guard let item = items?[index] else { return }
        
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
    override func updateModel(at index: Int) {
        super.updateModel(at: index)
        
        deleteItem(at: index)
    }

}


// MARK: - TableView

extension ToDoListVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isComplete ? .checkmark : .none
        } else {
            cell.textLabel?.text = "Empty"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateItemCompletionStatus(at: indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
}

// MARK: - SearchBar

extension ToDoListVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
