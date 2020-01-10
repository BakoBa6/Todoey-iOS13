//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class ToDoListViewController: SwipeTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var items:Results<Item>!
    let realm = try!Realm()
    var selectedCategory:Category?{
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        loadData()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        searchBar.barTintColor = UIColor(hexString: selectedCategory!.color)
        
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor(hexString: selectedCategory!.color)
        title = selectedCategory?.name
        navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString: selectedCategory!.color)!, returnFlat: true)
        let textAttributes = [NSAttributedString.Key.foregroundColor:ContrastColorOf(UIColor(hexString: selectedCategory!.color)!, returnFlat: true)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    //MARK: - add button pressed
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Items", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Item", style: .default) { (action) in
            do{
                try? self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.date = Date()
                    self.selectedCategory?.items.append(newItem)
                }
            }
            
            self.tableView.reloadData()
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelAction)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add new item"
            textField = alertTextField
            }


        present(alert, animated: true, completion: nil)
    }
//MARK: - loading and deleting items
    func loadData(){
       
            
                items = selectedCategory?.items.sorted(byKeyPath: "date", ascending: true)
               
          
          tableView.reloadData()
    }
    override func delete(at indexPath:IndexPath){
          do{
            super.delete(at: indexPath)
                try self.realm.write {
                self.realm.delete(self.items[indexPath.row])
                }
                }catch{
                print(error.localizedDescription)

                }
        
            }


}

//MARK: - table view data cource methods:
extension ToDoListViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel!.text = items[indexPath.row].title
        cell.backgroundColor = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(items.count+2))

        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        
        if items[indexPath.row].isDone == false{
            cell.accessoryType = .none        }
        else{
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do{
            try!realm.write {
                items[indexPath.row].isDone = !items[indexPath.row].isDone
            }
        }
        tableView.reloadData()
        

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - searchbar part
extension ToDoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0{
            loadData()
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
            }
            
        }
        else{
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@ ", searchBar.text!)
                items = items.filter(predicate).sorted(byKeyPath: "date", ascending: true)
                tableView.reloadData()
        }
    }
    
}
