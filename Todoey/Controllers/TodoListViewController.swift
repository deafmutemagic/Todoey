//
//  ViewController.swift
//  Todoey
//
//  Created by Christopher Murray on 4/3/19.
//  Copyright © 2019 Christopher Murray. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    //MARK: Define variables
    var toDoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
    }

    //MARK: Tableview Datasource Methods:
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    //MARK: TableView Delegate Methods
    
//    didSelectRowAt tells delegate which row was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error selecting item at row, /(error)")
            }
        }
        
        self.tableView.reloadData()

//        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once user clicks "Add Item"
            print(textField.text!)
            
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new item, \(error)")
                }
            } 
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new Todoey item"
            
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadItems() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }

}
//MARK: Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] @%", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

            //main = main thread; async = asynchronous (same time) method
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }

    }
    
    
}

