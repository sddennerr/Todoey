//
//  ViewController.swift
//  Todoey
//
//  Created by dener barbosa on 10/9/18.
//  Copyright © 2018 dener barbosa. All rights reserved.
//

import UIKit
//	import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {

   
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
           loadItems()
        }
    }
    
    
    override func viewDidLoad()
    {
    
           super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    //MARK - tableviwm Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            //ternary operator
            //value = condition ? valueIfTrue : ValueIfFalse
            
            cell.accessoryType = item.done  ? .checkmark : .none
            
            
        } else {
            cell.textLabel?.text = "No Items added"
        }
        
        
        
        return cell
    }
    
    //MARK - Tablebiew Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(item)
                    item.done = !item.done
                }
            }catch {
                print("Error saving done status, \(error)")
            }
        }
      //saveItems()
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our UIalert
           
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error savinf new items , \(error)")
                }
                
                
            }
//
            self.tableView.reloadData()
    
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            
            
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
//    func saveItems() {
//      //  let encoder = PropertyListEncoder()
//        do {
//
//
//            try context.save()
//         } catch {
//            print("Error saving context \(error)")
//
//
//        }
//        self.tableView.reloadData()
//
//    }
    
    func loadItems() {
     //   let request : NSFetchRequest<Item> = Item.fetchRequest()
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    
}

extension TodoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated" , ascending: true)
        
        
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
            }

        }
    }

}

