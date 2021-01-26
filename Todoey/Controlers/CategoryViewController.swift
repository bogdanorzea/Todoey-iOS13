//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Bogdan Orzea on 1/24/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadData()
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
                let category = Category(context: self.context)
                category.name = categoryName

                self.saveData()
            }
        })

        self.present(alertDialog, animated: true)
    }

    // MARK: - TabelView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = category.name

        return cell
    }

    // MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems", let indexPath = self.tableView.indexPathForSelectedRow {
            let destination = segue.destination as! TodoListViewController
            destination.category = categories[indexPath.row]
        }
    }

    // MARK: - Data manipulation methods
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error while fetching categories: \(error)")
        }

        tableView.reloadData()
    }

    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error while saving categories: \(error)")
        }

        self.loadData()
    }
}
