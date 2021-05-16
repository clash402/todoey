//
//  CategoryVC.swift
//  todoey
//
//  Created by Josh Courtney on 5/7/21.
//

import UIKit
import RealmSwift

class CategoryVC: SwipeTableVC {
    
    let realm = try! Realm()
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ToDoListVC else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        vc.category = categories?[indexPath.row]
    }
    
    @IBAction func addBtnTapped(_ sender: UIBarButtonItem) {
        presentAddCategoryAlert { title in
            self.saveCategory(with: title)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Alerts
    
    func presentAddCategoryAlert(_ handler: @escaping (_ categoryTitle: String)->()) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            guard let text = textField.text else { return }
            
            if text != "" {
                handler(text)
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data
    
    func saveCategory(with title: String) {
        let cateogry = Category()
        cateogry.title = title
        
        do {
            try realm.write {
                realm.add(cateogry)
            }
        } catch {
            print(error)
        }
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
    }
    
    func deleteCategory(at index: Int) {
        guard let category = categories?[index] else { return }
        
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print(error)
        }
    }
    
    override func updateModel(at index: Int) {
        super.updateModel(at: index)
        
        deleteCategory(at: index)
    }
    
}


// MARK: - TableView

extension CategoryVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categories?[indexPath.row]
        
        cell.textLabel?.text = category?.title ?? "Empty"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toToDoListVC", sender: self)
    }
    
}
