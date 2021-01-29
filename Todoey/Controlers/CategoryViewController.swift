//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Bogdan Orzea on 1/24/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    lazy var realm = try! Realm()

    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadCategories()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        cell.textLabel?.text =  categories?[indexPath.row].name ?? "No categories added yet"

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
}
