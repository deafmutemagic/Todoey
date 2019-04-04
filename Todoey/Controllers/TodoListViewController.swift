//
//  ViewController.swift
//  Todoey
//
//  Created by Christopher Murray on 4/3/19.
//  Copyright © 2019 Christopher Murray. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    //MARK: Define variables
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        // Do any additional setup after loading the view, typically from a nib.
//        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
//            itemArray = items
//        }
//

        
        print(dataFilePath)
        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Defeat the Demogorgon"
//        itemArray.append(newItem3)
        
//        loadItems()
    }

    //MARK: Tableview Datasource Methods:
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cellForRowAt Called")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: TableView Delegate Methods
    
    //didSelectRowAt tells delegate which row was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once user clicks "Add Item"
            print(textField.text!)
            
            //self.itemArray.append(textField.text!)
            
            let addedItem = Item(context: self.context)
            
            addedItem.title = textField.text!
            addedItem.done = false
            
            self.itemArray.append(addedItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new Todoey item"
            
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
//    func loadItems() {
//        if let dataURL = try? Data(contentsOf: dataFilePath!){
//        let decoder = PropertyListDecoder()
//
//        do {
//            itemArray = try decoder.decode([Item].self, from: dataURL)
//        } catch {
//            print("Error decoding data, \(error)")
//        }
//        }
//    }
}

