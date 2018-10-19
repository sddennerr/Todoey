//
//  ViewController.swift
//  Todoey
//
//  Created by dener barbosa on 10/9/18.
//  Copyright © 2018 dener barbosa. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    //let defaults = UserDefaults.standard
    
  //  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
   // print(dataFilePath)
    
    
    override func viewDidLoad()
    {
    
           super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //searchBar.delegate = self
        
//
//           let newItem = Item()
//           newItem.title = "Find Mike"
//           itemArray.append(newItem)
//
//          let newItem2 = Item()
//          newItem2.title = "Find Mike"
//          itemArray.append(newItem2)
//
//         let newItem3 = Item()
//         newItem3.title = "Find Mike"
//         itemArray.append(newItem3)
    //   let request : NSFetchRequest<Item> = Item.fetchRequest()
     //  loadItems()
        

        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
//
        // Do any additional setup after loading the view, typically from a nib.
    }
    //MARK - tableviwm Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        //ternary operator
        //value = condition ? valueIfTrue : ValueIfFalse
        
        cell.accessoryType = item.done  ? .checkmark : .none
        
        
        return cell
    }
    
    //MARK - Tablebiew Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")
       
      //  context.delete(itemArray[indexPath.row])
       //  itemArray.remove(at: indexPath.row)
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
      //  tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our UIalert
           
           
          
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            //self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            
            
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    func saveItems() {
      //  let encoder = PropertyListEncoder()
        do {
        
            
            try context.save()
         } catch {
            print("Error saving context \(error)")
        
            
        }
        self.tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
     //   let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        //        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        do {
        itemArray =  try context.fetch(request)
        } catch {
            print("Error fechting data from context \(error)")
        }
        tableView.reloadData()
    }
    
    
}

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     
        let request : NSFetchRequest<Item> = Item.fetchRequest()
       
        let predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
       
        loadItems(with: request, predicate: predicate)

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

