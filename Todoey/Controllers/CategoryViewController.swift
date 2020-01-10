    import UIKit
    import RealmSwift
    import ChameleonFramework
    class CategoryViewController: SwipeTableViewController{
        @IBOutlet weak var searchBar: UISearchBar!
        
        let realm = try! Realm()
       
        var categories:Results<Category>!
        var textField = UITextField()
        
    override func viewDidLoad() {
                 super.viewDidLoad()
                 searchBar.delegate = self
                 loadItems()
                 tableView.rowHeight = 80
                 tableView.separatorStyle = .none
        searchBar.barTintColor = #colorLiteral(red: 0.08781994134, green: 0.3995584249, blue: 0.2878653109, alpha: 1)
             }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.08781994134, green: 0.3995584249, blue: 0.2878653109, alpha: 1)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        let indexPath = tableView.indexPathForSelectedRow
        destinationVC.selectedCategory = categories![indexPath!.row]
    }

//MARK: - add button pressed
        @IBAction func addPressed(_ sender: UIBarButtonItem) {
            let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                let newCategory = Category()
                newCategory.name = self.textField.text!
                newCategory.color = UIColor.randomFlat().hexValue()
                self.save(category: newCategory)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "add an item"
                self.textField = alertTextField
                
            }
            alert.addAction(action)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
     
        //MARK: - tableview dataSource
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categories!.count
        }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
//         
            cell.textLabel?.text = categories![indexPath.row].name
            cell.backgroundColor = UIColor(hexString: categories[indexPath.row].color)
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString:  categories[indexPath.row].color)! , returnFlat: true)
            return cell
        }
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "cellIdentifier", sender: self)
        }
      
           
        
    //MARK: - saving and loading and deleting
        func save(category:Category){
            do{
                
                try realm.write {
                    realm.add(category)
                }
                
            }catch{
                print(error.localizedDescription)
            }
            tableView.reloadData()
        }
        func loadItems(predicate:NSPredicate? = nil){
            if let predicate = predicate{
                categories = realm.objects(Category.self).filter(predicate)
            }else{
                categories = realm.objects(Category.self)
            }
            
            tableView.reloadData()
           
            
        }
        
        override func delete(at indexPath:IndexPath){
              do{
                super.delete(at: indexPath)
                    try self.realm.write {
                    self.realm.delete(self.categories[indexPath.row])
                                                    }
                    }catch{
                    print(error.localizedDescription)

                    }
            
                }
        
    }
    
    //MARK: - searchbar delegate methods
    extension CategoryViewController:UISearchBarDelegate{
          func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                 
             }
             
             func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                 if searchBar.text!.count == 0{
                     loadItems()
                     DispatchQueue.main.async {
                         
                         searchBar.resignFirstResponder()
                     }
                     
                 }
                 else{

                     let predicate = NSPredicate(format: "name CONTAINS[cd] %@ ", searchBar.text!)
                  categories = categories.filter(predicate).sorted(byKeyPath: "name", ascending: true)
                                       tableView.reloadData()
                 }
             }
    }
