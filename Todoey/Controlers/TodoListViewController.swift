//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    lazy var realm = try! Realm()

    var items: Results<Item>?

    var category: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    // MARK: - TabelView DataSource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        // Configure the cell’s content
        if let item = items?[indexPath.row] {
            cell.textLabel!.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel!.text = "No todos added yet"
            cell.accessoryType = .none
        }

        return cell
    }

    // MARK: - TableView Delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try self.realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error while updading item: \(error)")
            }
        }

        self.tableView.reloadData()
    }

    // MARK: - Add new item

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoy item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            if let selectedCategory = self.category {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        item.done = false

                        selectedCategory.items.append(item)
                    }
                } catch {
                    print("Error while saving item: \(error)")
                }

                self.tableView.reloadData()
            }
        }

        alert.addAction(action)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        present(alert, animated: true)
    }

    // MARK: - Model manipulation

    func loadItems() {
        items = category?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }

    override func delete(at indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try self.realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error while deleting item: \(error)")
            }
        }
    }
}

// MARK: - UISearchBar methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, searchText.count > 0 {
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            items = items?.filter(predicate).sorted(byKeyPath: "dateCreatedAt", ascending: true)

            self.tableView.reloadData()
        }
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
