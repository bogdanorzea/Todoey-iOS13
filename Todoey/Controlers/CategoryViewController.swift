//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Bogdan Orzea on 1/24/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    lazy var realm = try! Realm()

    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadCategories()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let color = UIColor(hexString: "#1D9BF6") {
            let contrastColor = ContrastColorOf(color, returnFlat: true)
            configureNavigationBar(largeTitleColor: contrastColor, backgroundColor: color, tintColor: contrastColor)
        }
    }

    // MARK: - Add new categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var tempTextField = UITextField()

        let alertDialog = UIAlertController(title: "Add category", message: nil, preferredStyle: .alert)
        alertDialog.addTextField { textField in
            textField.placeholder = "Create new category"
            tempTextField = textField
        }
        alertDialog.addAction(UIAlertAction(title: "Add", style: .default) { action in
            if let categoryName = tempTextField.text {
                let category = Category()
                category.name = categoryName
                category.hexColor = UIColor.randomFlat().hexValue()

                self.save(category: category)
            }
        })

        self.present(alertDialog, animated: true)
    }

    // MARK: - TabelView DataSource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let category = categories?[indexPath.row], let color = UIColor(hexString: category.hexColor) {
            cell.textLabel?.text =  category.name
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            cell.backgroundColor = color
        } else {
            cell.textLabel?.text =  "No categories added yet"
            cell.backgroundColor = UIColor.white
        }

        return cell
    }

    // MARK: - TableView Delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems", let indexPath = self.tableView.indexPathForSelectedRow {
            let destination = segue.destination as! TodoListViewController
            destination.category = categories?[indexPath.row]
        }
    }

    // MARK: - Data manipulation methods

    func loadCategories() {
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }

    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error while saving categories: \(error)")
        }

        self.loadCategories()
    }

    override func delete(at indexPath: IndexPath) {
        if let categoryToDelete = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryToDelete.items)
                    self.realm.delete(categoryToDelete)
                }
            } catch {
                print("Error deleting the category: \(error)")
            }
        }
    }
}
