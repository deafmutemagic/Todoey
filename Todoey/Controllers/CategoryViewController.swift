//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Christopher Murray on 5/3/19.
//  Copyright © 2019 Christopher Murray. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    //MARK: - Define Variables
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
       
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return categoryArray.count
        
    }
    
    
    //MARK: - TableView Delegation Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    

    //MARK: - Data Manipulation Methods
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
    }

    
    //MARK: - Add New Categories
    
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let addAlert = UIAlertController(title: "Add Todoey Category", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add Category", style: .default) { (addAction) in
            
            print(textField.text!)
            
            let addedCategory = Category(context: self.context)
            
            addedCategory.name = textField.text
            
            //            print(addedCategory.name)
            
            self.categoryArray.append(addedCategory)
            
            print(self.categoryArray)
            
            self.saveCategories()
            
            
        }
        
        addAlert.addTextField { (addAlertTextField) in
            
            textField = addAlertTextField
            addAlertTextField.placeholder = "Add New Category"
            
        }
        
        addAlert.addAction(addAction)
        
        present(addAlert, animated: true, completion: nil)
        
    }

}
    





